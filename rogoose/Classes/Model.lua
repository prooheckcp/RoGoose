--!strict
local DataStoreService = game:GetService("DataStoreService")

local Schema = require(script.Parent.Schema)
local Profile = require(script.Parent.Profile)
local ModelType = require(script.Parent.Parent.Enums.ModelType)
local Promise = require(script.Parent.Parent.Vendor.Promise)
local GeneratePlayerKey = require(script.Parent.Parent.Functions.GeneratePlayerKey)

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model._profiles = {} :: {[string]: Profile.Profile}
Model._schema = Schema.new({})
Model._dataStore = nil :: DataStore?
Model._name = ""
Model._modelType = ModelType.String :: ModelType.ModelType

--[=[
    Creates a new instance of a Model

    @param modelName string -- The name of the model
    @param schema Schema -- The schema that will represent your model
    @param modelType ModelType -- (optional)

    @return Model
]=]
function Model.new(modelName: string, schema: Schema.Schema, modelType: ModelType.ModelType)
    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema
    self._profiles = {}
    self._modelType = modelType

    return self
end

--[=[
    Proxy for Model.new()
    Used to clone Mongoose's syntax https://mongoosejs.com/docs/models.html

    @param modelName string -- The name of the model
    @param schema Schema -- The schema that will represent your model
    @param modelType ModelType -- (optional)

    @return Model
]=]
function Model.create(modelName: string, schema: Schema.Schema, modelType: ModelType.ModelType)
    return Model.new(modelName, schema, modelType)
end

function Model:Find(key: Player | string): Profile.Profile?
    return self._profiles[key]
end

function Model.__tostring(model: Model): string
    return model._name
end

export type Model = typeof(Model)

return Model