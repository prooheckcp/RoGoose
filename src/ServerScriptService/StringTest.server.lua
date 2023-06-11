local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)

if true then
    return
end

print("TotalGold", ModelLoader.ServerSchema:Get("Global", "TotalGold"))
ModelLoader.ServerSchema:Set("Global", "TotalGold", 10)
print("TotalGold", ModelLoader.ServerSchema:Get("Global", "TotalGold"))

ModelLoader.ServerSchema:Set("Global", "GlobalWallet.Yen", "UwU")
print("Yen", ModelLoader.ServerSchema:Get("Global", "GlobalWallet.Yen"))