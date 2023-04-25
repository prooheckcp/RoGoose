--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local DefaultSettings = require(script.Constants.DefaultSettings)

local RoGoose = {}

--caches
RoGoose._cachedModels = {} :: {[string]: Model.Model}
RoGoose._cachedProfiles = {} :: {}

function RoGoose:Init()
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

--[=[
    Loads a given model
]=]
function RoGoose:LoadModel(model: Model)
    
end

function RoGoose:_PlayerAdded(player: Player)
    
end

function RoGoose:_PlayerRemoving(player: Player)
    
end

RoGoose:Init()

return RoGoose