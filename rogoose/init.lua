local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Signal = require(script.Vendor.Signal)
local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local ModelType = require(script.Enums.ModelType)
local Errors = require(script.Constants.Errors)
local Options = require(script.Structs.Options)

local Trove = require(script.Vendor.Trove)
local Signals = require(script.Constants.Signals)

local Settings = require(script.Constants.Settings)

local SESSION_LOCK_DATASTORE: string = "SessionLockStore"

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

    game:BindToClose(function() -- TO-DO
        --self:_AutoSaving(Settings.AutoSaveInterval)
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
    local intervalDelta: number = Settings.AutoSaveInterval/playerCount

    if savingDelta > intervalDelta then
        self._lastSave = currentTick
        
        for _, player: Player in players do
            for _, model: Model.Model in self._cachedModels do
                if model._modelType ~= ModelType.Player then
                    continue
                end

                local profile: Profile? = model:GetProfile(player)

                if profile then
                    continue
                end

                print("Profile Saved!")

                local profileDelta: number = currentTick - profile._lastSave

                if profileDelta > Settings.AutoSaveInterval * 0.85 then
                    model:_SaveProfile(player)
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

    model:_LoadProfile(player)
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