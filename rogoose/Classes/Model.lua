--!strict
local DataStoreService = game:GetService("DataStoreService")

local Options = require(script.Parent.Parent.Structs.Options)
local Schema = require(script.Parent.Schema)
local Profile = require(script.Parent.Profile)
local ModelType = require(script.Parent.Parent.Enums.ModelType)
local Promise = require(script.Parent.Parent.Vendor.Promise)
local Trove = require(script.Parent.Parent.Vendor.Trove)
local Signals = require(script.Parent.Parent.Constants.Signals)

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
Model._options = Options.new()
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
    self._options = options

    Signals.ModelCreated:Fire(self)

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

--[[
function Model:Get(key: Player | string): table
    
end

function Model:Find<T>(key: Player | string, index: string): T

end    
]]


function Model:_GetAsync(key: string)
    return Promise.new(function(resolve, reject)
        local a, b, c = self._dataStore:UpdateAsync(key, function(oldValue: any?)
            return oldValue
        end)

        print(a, b, c)
    end)
end

--[[
    Player Managed DataStore
    ====================
]]
function Model:_LoadProfile(player: Player): ()
    local key: string = player.UserId..self._options.savingKey

    self:_GetAsync(key)
end

function Model.__tostring(model: Model): string
    return model._name
end

export type Model = typeof(Model)

return Model