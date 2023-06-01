local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)

local gold: number = ModelLoader.ServerSchema:Get("Global", "TotalGold")

print("Global Gold: ", gold)