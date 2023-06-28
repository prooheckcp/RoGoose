local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)

local GlobalCounter: RoGoose.Model = RoGoose:GetModelAsync("GlobalCounter")


GlobalCounter:LoadProfile("Test")
