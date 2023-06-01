local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)

Players.PlayerAdded:Connect(function(player: Player)
    local profile: RoGoose.Profile = ModelLoader.Currencies:GetProfile(player)

    --[[
        ==================== Testing Profile ====================
    ]]
        local profileGold: number = profile:Get("Gold") -- 0

        print("Profile Gold: ", profileGold)
    --[[
        ==================== Testing Model ====================
    ]]
    
    local modelGold: number = ModelLoader.Currencies:Get(player, "Gold")

    print ("Model Gold: ", modelGold)
end)