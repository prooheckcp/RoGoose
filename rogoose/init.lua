local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local ModelType = require(script.Enums.ModelType)
local Errors = require(script.Constants.Errors)
local Options = require(script.Structs.Options)
local Signals = require(script.Constants.Signals)
local Settings = require(script.Constants.Settings)
local GetKey = require(script.Functions.GetKey)
local KickMessages = require(script.Constants.KickMessages)
local Warnings = require(script.Constants.Warnings)
local Warning = require(script.Functions.Warning)

--[=[
    @class RoGoose

    Main object for RoGoose. Contains references to the necessary classes and enums.
]=]
local RoGoose = {}

--Exposed types
export type Schema = Schema.Schema
export type Model = Model.Model
export type Profile = Profile.Profile
export type ModelType = ModelType.ModelType
export type Options = Options.Options

--Exposed Classes
RoGoose.Schema = Schema
RoGoose.Model = Model

--Exposed Structs
RoGoose.Options = Options

--Exposed Enums
RoGoose.ModelType = ModelType

--Properties
RoGoose._cachedModels = {} :: {[string]: Model.Model} -- Model Name / Model Instance
RoGoose._currentSaveDelta = 0 :: number
RoGoose._lastSave = tick() :: number
RoGoose._tasks = {} :: {[string]: boolean} -- This caches tasks currently being done by the library, it shouldn't close the server before they all finish! (Should only bound tasks that are of severe importance)

--[=[
    This is the main function of the program and it is used to set up some events
    and initialize the RoGoose object.

    @private

    @return ()
]=]
function RoGoose:_Init(): ()
    if not RunService:IsServer() then
        self:_Error(Errors.ClientAttempt)
    end

    Signals.ModelCreated:Connect(function(model: Model.Model)
        self:_AddModel(model)
    end)

    for _, player: Player in Players:GetPlayers() do
        self:_PlayerJoined(player)
    end

    Players.PlayerAdded:Connect(function(player: Player)
        self:_PlayerJoined(player)
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        self:_PlayerLeft(player)
    end)

    RunService.Heartbeat:Connect(function(deltaTime: number)
        self:_AutoSaving(deltaTime)
    end)

    game:BindToClose(function()
        while next(self._tasks) ~= nil do
            task.wait()
        end

        Warning(Warnings.FinishedServerTasks)
    end)
end

--[=[
    Function to manage an equal distribution for autosaving purposes

    @private

    @param deltaTime number -- The time between each heartbeat

    @return ()
]=]
function RoGoose:_AutoSaving(deltaTime: number): ()
    local currentTick: number = tick()
    local savingDelta: number = currentTick - self._lastSave
    local players: {Player} = Players:GetPlayers()
    local playerCount: number = #players

    if playerCount <= 0 then
        return
    end

    local intervalDelta: number = Settings.AutoSaveInterval/playerCount

    if savingDelta > intervalDelta then
        self._lastSave = currentTick
        
        for _, player: Player in players do
            for _, model: Model.Model in self._cachedModels do
                if model._modelType ~= ModelType.Player then
                    continue
                end

                local profile: Profile? = model:GetPlayerProfile(player)

                if not profile then
                    continue
                end

                local profileDelta: number = currentTick - (profile :: Profile)._lastSave

                if profileDelta > Settings.AutoSaveInterval * 0.85 then
                    model:SaveProfile(player)
                end                
            end
        end
    end

    self._currentSaveDelta += deltaTime

    if self._currentSaveDelta > Settings.AutoSaveInterval then -- Avoid overflow
        self._currentSaveDelta -= Settings.AutoSaveInterval
    end
end

--[=[
    Called whenever the player joins the server

    @private
    @param player Player

    @return ()
]=]
function RoGoose:_PlayerJoined(player: Player): ()
    local failedToLoad: boolean = false

    -- Check if any of the player sessions are locked or not
    -- TO-DO Make this parallel instead of single threaded
    for _, model: Model.Model in self._cachedModels do
        if model._modelType ~= ModelType.Player then
            continue
        end

        local sessionLockKey: string = GetKey(player, model._name)
        local attempts: number = 0

        while model:_IsSessionLocked(sessionLockKey) do
            attempts += 1

            if attempts > Settings.MaxSessionLockingAttempts then
                failedToLoad = true
                break
            end

            task.wait(1)
        end

        if failedToLoad then -- No point on going any further
            break
        end
    end

    if failedToLoad then -- We don't want to deal with this kind of player
        local taskId: string = "ReleaseProfile"..tostring(player.UserId)
        self._tasks[taskId] = true

        task.delay(Settings.AutoReleaseTimer, function()
            for _, model: Model.Model in self._cachedModels do
                if model._modelType ~= ModelType.Player then
                    continue
                end

                model:ReleaseProfile(player)
            end

            self._tasks[taskId] = nil
        end)

        player:Kick(KickMessages.SessionLocked)
        return
    end

    for _, model: Model.Model in self._cachedModels do
        if model._modelType ~= ModelType.Player then
            continue
        end

        self:_LoadPlayer(player, model)
    end
end

--[=[
    Called whenever a player leaves the game

    @private

    @param player Player

    @return ()
]=]
function RoGoose:_PlayerLeft(player: Player): ()
    for _, model: Model.Model in self._cachedModels do
        if model._modelType ~= ModelType.Player then
            continue
        end

        model:_UnloadProfile(player)
    end
end

--[=[
    Adds a RoGoose Model to the cache and loads the player's model

    @private

    @model Model

    @return ()
]=]
function RoGoose:_AddModel(model: Model.Model): ()
    self._cachedModels[model._name] = model

    if model._modelType == ModelType.Player then
        self:_LoadPlayerModel(model)
    end
end

--[[
    Loads a model by creating profiles for all the players

    @private

    @param model Model -- The model to load

    @return ()
]]
function RoGoose:_LoadPlayerModel(model: Model.Model): ()
    for _, player: Player in Players:GetPlayers() do
        self:_LoadPlayer(player, model)
    end
end

--[=[
    Loads a player's profile for a specific model

    @private

    @param player Player -- The player to load the profile for
    @param model Model -- The model to load the profile for

    @return ()
]=]
function RoGoose:_LoadPlayer(player: Player, model: Model.Model): ()
    if not Players:GetPlayerByUserId(player.UserId) then -- Player disconnected
        return
    end

    model:LoadProfile(player)
end

--[=[
    Used as a shortcut to error() with a header

    @private

    @param message string -- The message to error with

    @return ()
]=]
function RoGoose:_Error(message: string): ()
    error(Errors.Header..message, 2)
end

RoGoose:_Init()

return RoGoose