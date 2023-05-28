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
        self:_LoadPlayer(player)
    end

    Players.PlayerAdded:Connect(function(player: Player)
        self:_PlayerJoined(player)
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        -- Save stuff and session locking and bla bla bla
    end)
end

--[=[
    Called whenever the player joins the server

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
    print("Load Player!")
    model:_LoadProfile(player)
end

--[=[
    Used as a shortcut to error() with a header
]=]
function RoGoose:_Error(message: string): ()
    error(Errors.Header..message, 2)
end

RoGoose:_Init()

return RoGoose