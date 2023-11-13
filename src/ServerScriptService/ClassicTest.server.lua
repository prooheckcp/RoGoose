--[[
	Description			Used to test classic data stores
	Author				Vasco S. (prooheckcp)
	Last updated on		13rd November 2023
	
	Copyright
		All rights reserved 2023, @prooheckcp
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)

type Model = RoGoose.Model

local classicStore: Model = RoGoose:GetModelAsync("ClassicStore")

print("Current Gold:", classicStore:Get("test", "Gold"))
print("Set Gold to 100")
classicStore:Set("test", "Gold", 100)
print("Current Gold:", classicStore:Get("test", "Gold"))