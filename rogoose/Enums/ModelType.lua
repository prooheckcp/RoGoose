local ModelType = {
    Player = 0,
    String = 1,
}

table.freeze(ModelType)

export type ModelType = typeof(ModelType)

return ModelType