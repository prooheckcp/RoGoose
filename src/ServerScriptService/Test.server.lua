local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)
local UnitTestsConstants = require(script.Parent.UnitTestsConstants.Player)
local TestEz = require(ReplicatedStorage.TestEz)

Players.PlayerAdded:Connect(function(player: Player)
    UnitTestsConstants.Player = player

    --[[
    local profile: RoGoose.Profile = ModelLoader.Currencies:GetProfile(player)

    print(profile:Get("Gold")) -- 0
    print(ModelLoader.Currencies:Get(player, "Gold"))        
    ]]


    --TestEz.TestBootstrap:run(script.Parent.UnitTests:GetChildren())
end)

local gold: number = ModelLoader.ServerSchema:Get("Global", "TotalGold")

print("Global Gold: ", gold)