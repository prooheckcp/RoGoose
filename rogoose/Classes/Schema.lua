--!strict

--[=[
    @class Schema

    Schemas are essentially data containers that hold information about your model.
    They will describe what data your model will hold and what type of data it will be.
    It also assigns the default values of your model.
]=]
local Schema = {}
Schema.__index = Schema
Schema.type = "DatabaseSchema"

--[=[
    Creates a new instance of a Schema

    E.g

    ```lua
    local currenciesSchema = RoGoose.Schema.new({
        Gold = 0,   -- The player will start with 0 gold
        Cash = 20,  -- The player will start with 20 of cash
    })

    RoGoose.Model.new("Currencies", currenciesSchema)
    ````

    @param schema table -- The schema that will represent your model

    @return Schema
]=]
function Schema.new(schema: {[string]: any}): Schema
    local self = setmetatable({}, Schema)
    self._schema = schema

    return self
end

export type Schema = typeof(Schema.new({}))

return Schema