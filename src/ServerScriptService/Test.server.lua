local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)


ModelLoader.Currencies.PlayerAdded:Connect(function(player: Player, profile: RoGoose.Profile, firstTime: boolean)
    print(player, profile, firstTime)
end)