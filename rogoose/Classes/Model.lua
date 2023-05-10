--!strict
local Schema = require(script.Parent.Schema)
local InternalSignals = require(script.Parent.Parent.Constants.InternalSignals)
local Profile = require(script.Parent.Profile)
local GeneratePlayerKey = require(script.Parent.Parent.Functions.GeneratePlayerKey)

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model._profiles = {} :: {[string]: Profile.Profile}
Model._schema = Schema.new({})
Model._dataStore = nil :: DataStore?
Model._name = ""

function Model.new(modelName: string, schema: Schema.Schema)
    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema
    self._profiles = {}
    
    InternalSignals.ModelCreated:Fire(self)

    return self
end

function Model:Create(key: Player | string, startingData: {[string]: any}): Profile.Profile
    local finalKey: string = ""

    if typeof(key) == "Instance" and key:IsA("Player") then
        finalKey = GeneratePlayerKey(key)
    else
        finalKey = key
    end

    local newProfile: Profile.Profile = Profile.new()
    newProfile._data = startingData
    self._profiles[finalKey] = newProfile

    return newProfile
end

function Model:Find(key: Player | string): Profile.Profile?
    return self._profiles[key]
end

function Model:_GetKey(key: Player | string): string
    local finalKey: string = ""

    if typeof(key) == "Instance" and key:IsA("Player") then
        finalKey = GeneratePlayerKey(key)
    else
        finalKey = key
    end

    return finalKey
end

function Model.__tostring(model: Model): string
    return tostring(model._schema)
end

export type Model = typeof(Model)

return Model