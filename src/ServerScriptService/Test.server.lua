local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)

RoGoose.PlayerAdded:Connect(function(player: Player)
    print(player.Name, " joined the game")
end)

RoGoose.PlayerRemoving:Connect(function(player: Player)
    print(player.Name, " player left")
end)