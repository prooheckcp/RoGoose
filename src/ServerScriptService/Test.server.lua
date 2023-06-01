local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UnitTestsConstants = require(script.Parent.UnitTestsConstants.Player)
local TestEz = require(ReplicatedStorage.TestEz)

Players.PlayerAdded:Connect(function(player: Player)
    UnitTestsConstants.Player = player
    TestEz.TestBootstrap:run(script.Parent.UnitTests:GetChildren())
end)