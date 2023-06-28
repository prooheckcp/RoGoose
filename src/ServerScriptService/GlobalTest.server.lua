local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)

local GlobalCounter: RoGoose.Model = RoGoose:GetModelAsync("GlobalCounter")


local profile: RoGoose.Profile? = GlobalCounter:LoadProfile("Test")