local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)
local Options = RoGoose.Options
local ModelType = RoGoose.ModelType

local currenciesSchema = RoGoose.Schema.new({
    Gold = 0,
    Cash = 0,
    Wallet = {
        Yen = 0,
    }
})

local itemsSchema = RoGoose.Schema.new({
    Swords = {},
    Bows = {},
})

local ServerSchema = RoGoose.Schema.new({
    TotalGold = 5,
    TotalGems = 3,
})

return {
    Currencies = RoGoose.Model.new("Currencies", currenciesSchema),
    Items = RoGoose.Model.new("Items", itemsSchema),

    
    ServerSchema = RoGoose.Model.new("ServerSchema", ServerSchema, Options.new({
        modelType = ModelType.String
    })),
}