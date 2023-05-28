--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Options = require(script.Parent.Parent.Structs.Options)
local Schema = require(script.Parent.Schema)
local Profile = require(script.Parent.Profile)
local ModelType = require(script.Parent.Parent.Enums.ModelType)
local Trove = require(script.Parent.Parent.Vendor.Trove)
local Promise = require(script.Parent.Parent.Vendor.Promise)
local GeneratePlayerKey = require(script.Parent.Parent.Functions.GeneratePlayerKey)

type Trove = typeof(Trove.new())

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model._trove = nil :: Trove
Model._profiles = {} :: {[string]: Profile.Profile}
Model._schema = Schema.new({})
Model._dataStore = nil :: DataStore?
Model._name = ""
Model._trove = Trove.new() :: Trove
Model._modelType = ModelType.Player :: ModelType.ModelType

--[=[
    Creates a new instance of a Model

    @param modelName string -- The name of the model
    @param schema Schema -- The schema that will represent your model
    @param _options Options? -- (optional)

    @return Model
]=]
function Model.new(modelName: string, schema: Schema.Schema, _options: Options.Options?)
    local options: Options.Options = _options or Options.new()

    local self = setmetatable({}, Model)
    self._name = modelName
    self._schema = schema
    self._dataStore = DataStoreService:GetDataStore(modelName, options.scope, options.options)
    self._profiles = {}
    self._modelType = options.modelType
    self._trove = Trove.new()

    if options.modelType == ModelType.Player then

    end

    return self
end

--[=[
    Proxy for Model.new()
    Used to clone Mongoose's syntax https://mongoosejs.com/docs/models.html

    @param modelName string -- The name of the model
    @param schema Schema -- The schema that will represent your model
    @param _options Options? -- (optional)

    @return Model
]=]
function Model.create(modelName: string, schema: Schema.Schema, _options: Options.Options?)
    return Model.new(modelName, schema, _options)
end


function Model:Find(key: Player | string): Profile.Profile?
    return self._profiles[key]
end


--[=[
    Used to destroy the model and all of its profiles
]=]
function Model:Destroy()

end

--[[
    Player Managed DataStore
    ====================
]]


function Model.__tostring(model: Model): string
    return model._name
end

export type Model = typeof(Model)

return Model