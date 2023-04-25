--!strict
local Schema = {}
Schema.__index = Schema
Schema.type = "Schema"

function Schema.new(schema: {[string]: any}): Schema
    local self = setmetatable({}, Schema)
    self._schema = schema

    return self
end

export type Schema = typeof(Schema.new({}))

return Schema