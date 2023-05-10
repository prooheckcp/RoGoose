--!strict
local Schema = require(script.Parent.Schema)
local InternalSignals = require(script.Parent.Parent.Constants.InternalSignals)
local Profile = require(script.Parent.Profile)
local GeneratePlayerKey 

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model._profiles = {}

function Model.new(modelName: string, schema: Schema.Schema): Model
    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema
    self._profiles = {}
    
    InternalSignals.ModelCreated:Fire(self)

    return self
end

function Model:Create(key: Player | string, startingData: {[string]: any}): Profile
    local finalKey: string = ""

    if typeof(key) == "Instance" and key:IsA("Player") then

    else
        finalKey = key
    end
end

function Model.__tostring(model: Model): string
    return tostring(model._schema)
end

export type Model = typeof(Model.new("", Schema.new({})))

return Model