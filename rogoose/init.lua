--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Signal = require(script.Vendor.Signal)
local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local InternalSignals = require(script.Constants.InternalSignals)

--functions
local GeneratePlayerKey = require(script.Functions.GeneratePlayerKey)

local ERROR_TAG: string = "[RoGoose] [ERROR]:"
local SESSION_LOCK_DATASTORE: string = "SessionLockStore"

local RoGoose = {}

--Exposed types
export type Schema = Schema.Schema
export type Model = Model.Model
export type Profile = Profile.Profile

--Exposed Classes
RoGoose.Schema = Schema
RoGoose.Model = Model

--Signals
RoGoose.PlayerAdded = Signal.new() :: Signal.Signal<Player>
RoGoose.PlayerRemoving = Signal.new() :: Signal.Signal<Player>

--Caches
RoGoose._cachedModels = {} :: {[string]: Model.Model}
RoGoose._cachedDataStores = {} :: {[string]: DataStore}
RoGoose._sessionLockDataStore = nil :: DataStore?

function RoGoose:_ServerInit()
    InternalSignals.ModelCreated:Connect(function(model: Model)
        self:_LoadModel(model) -- Feeds the model into the system
    end)

    for _, player: Player in Players:GetPlayers() do
        self:_PlayerAdded(player)
    end

    Players.PlayerAdded:Connect(function(player: Player)
        self:_PlayerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        self:_PlayerRemoving(player)
    end)

    self._sessionLockDataStore = DataStoreService:GetDataStore(SESSION_LOCK_DATASTORE)
end

function RoGoose:_Error(message: string, level: number?): ()
    error(`{ERROR_TAG} {message}`, level or 1)
end

--[[
    [THIS SECTION IS USED TO MANAGE SESSION LOCK LOGIC]
]]

function RoGoose:_GetPlayerSessionLockStatus(player: Player): number?
    return self._sessionLockDataStore:UpdateAsync(GeneratePlayerKey(player), function(state)
        return state
    end)
end

function RoGoose:_LockSession(player: Player): ()
    self._sessionLockDataStore:UpdateAsync(GeneratePlayerKey(player), function()
        return os.time()
    end)
end

function RoGoose:_UnLockSession(player: Player): ()
    self._sessionLockDataStore:UpdateAsync(GeneratePlayerKey(player), function()
        return nil
    end)
end

function RoGoose:_PlayerAdded(player: Player)
    local isSessionLocked: boolean = self:_GetPlayerSessionLockStatus() ~= nil

    if isSessionLocked then
        player:Kick("Please Rejoin!")
        return
    end

    self.PlayerAdded:Fire(player)
end

function RoGoose:_PlayerRemoving(player: Player)
    self.PlayerRemoving:Fire(player)
end

--[=[
    Loads a given model
]=]
function RoGoose:_LoadModel(model: Model.Model): ()
    if self._cachedModels[model._name] then
        self:_Error(`Theres already a Model by the name of {model.Name}`)
        return
    end

    self._cachedModels[model._name] = model

    self._cachedDataStores[model._name] = DataStoreService:GetDataStore(model._name)
end

RoGoose:_ServerInit()

return RoGoose