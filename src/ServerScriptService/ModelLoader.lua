local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)

local currenciesSchema = RoGoose.Schema.new({
    Gold = 0,
    Cash = "",
})

local itemsSchema = RoGoose.Schema.new({
    Swords = {},
    Bows = {},
})

return {
    Currencies = RoGoose.Model.new("Currencies", currenciesSchema),
    Items = RoGoose.Model.new("Items", itemsSchema)
}