local ModelType = {
    Player = 0, -- Uses a profile system and automatically manages session locking and saving for player
    String = 1, -- Uses a profile system but requires manual session locking and saving
    Classic = 2, -- Behaves like a normal and classic Roblox DataStore
}

table.freeze(ModelType)

export type ModelType = typeof(ModelType)

return ModelType