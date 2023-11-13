local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)

local Currencies = RoGoose:GetModelAsync("Currencies")

local function playerAdded(player: Player)
    local profile: RoGoose.Profile? = ModelLoader.Currencies:GetPlayerProfile(player)

    if not profile then
        return
    end

    print("Gold: ", Currencies:Get(player, "Gold"))


    --[[
        ==================== Testing Profile ====================
    ]]
        profile:Set("Gold", 10)
        local profileGold: number = profile:Get("Gold") -- 0

        print("Profile Gold: ", profileGold)
    --[[
        ==================== Testing Model ====================
    ]]
    
    ModelLoader.Currencies:Set(player, "Gold", 5)
    local modelGold: number = ModelLoader.Currencies:Get(player, "Gold")

    print ("Model Gold: ", modelGold)
end

for _, player: Player in Players:GetPlayers() do
    playerAdded(player)
end

Players.PlayerAdded:Connect(function(player: Player)
    playerAdded(player)
end)