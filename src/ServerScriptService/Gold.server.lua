local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local RoGoose = require(ReplicatedStorage.RoGoose)

local Currencies: RoGoose.Model = RoGoose:GetModelAsync("Currencies")

Currencies.PlayerAdded:Connect(function(player: Player, data: RoGoose.Profile, firstTime: boolean)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local gold = Instance.new("IntValue")
    gold.Name = "💸Gold"
    gold.Value = data:Get("Gold")
    gold.Parent = leaderstats

    data:GetDataChangedSignal("Gold"):Connect(function(newGold: number, oldGold: number)
        gold.Value = newGold
    end)
end)

Currencies.PlayerRemoving:Connect(function(player: Player, data)
    print("Player left: ", player.Name)
end)

-- Simple coin game

local coin: BasePart = workspace.Coin
coin.Parent = ReplicatedStorage
local coinCount: number = 0

RunService.Heartbeat:Connect(function()
    if coinCount >= 10 then
        return
    end

    -- Spawn the coin at a random position with a range of 35 in the X and Z axis from the origin of the original coin
    local newCoin = coin:Clone()
    newCoin.Position = Vector3.new(
        coin.Position.X + math.random(-35, 35),
        coin.Position.Y + 10,
        coin.Position.Z + math.random(-35, 35)
    )
    newCoin.Parent = workspace

    coinCount += 1

    newCoin.Touched:Connect(function(part: BasePart)
        if (part.Parent :: Instance):FindFirstChild("Humanoid") then
            local player = game.Players:GetPlayerFromCharacter(part.Parent)
            if player then
                local data = Currencies:GetPlayerProfile(player)
                data:Increment("Gold", 1)

                newCoin:Destroy()
                coinCount -= 1
            end
        end
    end)
end)