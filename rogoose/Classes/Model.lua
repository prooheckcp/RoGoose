--!strict
local Schema = require(script.Parent.Schema)
local InternalSignals = require(script.Parent.Parent.Constants.InternalSignals)

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"

function Model.new(modelName: string, schema: Schema.Schema): Model
    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema
    
    InternalSignals.ModelCreated:Fire(self)

    return self
end

function Model.__tostring(model: Model): string
    return tostring(model._schema)
end

export type Model = typeof(Model.new("", Schema.new({})))

return Model