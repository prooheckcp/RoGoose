--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Signal = require(script.Vendor.Signal)
local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local DefaultSettings = require(script.Constants.DefaultSettings)
local InternalSignals = require(script.Constants.InternalSignals)

local ERROR_TAG: string = "[RoGoose] [ERROR]:"

local RoGoose = {}
--Exposed Classes
RoGoose.Schema = Schema
RoGoose.Model = Model

--Signals
RoGoose.PlayerAdded = Signal.new() :: Signal.Signal<Player>
RoGoose.PlayerRemoving = Signal.new() :: Signal.Signal<Player>

--Caches
RoGoose._cachedModels = {} :: {[string]: Model.Model}
RoGoose._cachedProfiles = {} :: {}

function RoGoose:GetPlayerModel(model: Model)
    
end

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
end

function RoGoose:_ClientInit()
    
end

--[=[
    Called whenever the user used a function at the wrong side.

    E.g, if the function should only be called in the client and is called in the server then it will error!
]=]
function RoGoose:_WrongSideError()
    
end

function RoGoose:_Error(message: string, level: number?): ()
    error(`{ERROR_TAG} {message}`, level or 1)
end

function RoGoose:_PlayerAdded(player: Player)
    
end

function RoGoose:_PlayerRemoving(player: Player)
    
end

--[=[
    Loads a given model
]=]
function RoGoose:_LoadModel(model: Model): ()
    if self._cachedModels[model.Name] then
        self:_Error(`Theres already a Model by the name of {model.Name}`)
        return
    end

    self._cachedModels[model.Name] = model
end

if RunService:IsClient() then
    RoGoose:_ClientInit()
elseif RunService:IsServer() then
    RoGoose:_ServerInit()
end

return RoGoose