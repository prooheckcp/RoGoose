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

local gold: number? = classicStore:Get("test", "Gold")

print("Gold: ", gold)