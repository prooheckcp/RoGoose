--!strict
local Schema = require(script.Parent.Schema)

local Model = {}
Model.__index = Model

function Model.new(modelName: string, schema: Schema.Schema): Model
    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema

    return self
end

export type Model = typeof(Model.new("", Schema.new({})))

return Model