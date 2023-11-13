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
    GlobalCounter = 0,
    BannedPlayers = {"Hello"},
})

local ClassicSchema = RoGoose.Schema.new({
    Gold = 0,
    Wallet = {
        Yen = 0,
    },
    Inventory = {
        InnerInventory = {}
    }
})

return {
    Currencies = RoGoose.Model.new("Currencies", currenciesSchema),
    Currencies2 = RoGoose.Model.new("Currencies", currenciesSchema),
    GlobalCounter = RoGoose.Model.new("GlobalCounter", GlobalCounter, Options.new({
        modelType = ModelType.String
    })),
    ClassicStore = RoGoose.Model.new("ClassicStore", ClassicSchema, Options.new({
        modelType = ModelType.Classic
    }))
}