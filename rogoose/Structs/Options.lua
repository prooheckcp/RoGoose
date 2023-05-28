--!strict
local ModelType = require(script.Parent.Parent.Enums.ModelType)

--[=[
    @class Options
    @tag Structs

    The options consist of a simple struct to feed the options you want into
    the model when you create it. This options will change the behavior of said model
]=]
local Options = {}
Options.__index = Options
Options.type = "Options"

---@prop scope string -- The scope of the model. This will be fed into the DataStoreService:GetDataStore() function
Options.scope = "global" :: string
--@prop options Instance? -- The options to feed into the DataStoreService:GetDataStore() function
Options.options = nil :: Instance?
--@prop modelType ModelType -- The type of model you want to create. Using Player as a key will result in a player specific model
Options.modelType = ModelType.Player :: ModelType.ModelType
--@prop savingKey string -- The key to save the data under. This will be used to save the data under a specific key in the DataStore
Options.savingKey = "" :: string

export type Options = {
    scope: string,
    options: Instance?,
    modelType: ModelType.ModelType,
    savingKey: string,
}

--[=[
    Creates a new instance of Options

    E.g

    ```lua
        local Options = RoGoose.Options
        local options = Options.new({
            scope = "global",
            options = nil,
            modelType = RoGoose.ModelType.Player
        })

        RoGoose.Model.create("Example", schema, options)
    ```

    @param options Options? -- The options to create the instance with

    @return Options
]=]
function Options.new(options: Options?): Options
    options = (options or {}) :: Options

    assert(options)

    local _options = {
        scope = options.scope or "global",
        options = options.options or nil,
        modelType = options.modelType or ModelType.Player,
        savingKey = options.savingKey or ""
    }

    return _options
end

return Options