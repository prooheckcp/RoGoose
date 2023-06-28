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

local GlobalCounter = RoGoose.Schema.new({
    GlobalCounter = 0
})

return {
    Currencies = RoGoose.Model.new("Currencies", currenciesSchema),
    --Items = RoGoose.Model.new("Items", itemsSchema),

    
    GlobalCounter = RoGoose.Model.new("GlobalCounter", GlobalCounter, Options.new({
        modelType = ModelType.String
    })),
}