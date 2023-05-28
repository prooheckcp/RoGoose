--!strict
local DataStoreService = game:GetService("DataStoreService")

local Options = require(script.Parent.Parent.Structs.Options)
local Schema = require(script.Parent.Schema)
local Profile = require(script.Parent.Profile)
local ModelType = require(script.Parent.Parent.Enums.ModelType)
local Promise = require(script.Parent.Parent.Vendor.Promise)
local Trove = require(script.Parent.Parent.Vendor.Trove)
local Signal = require(script.Parent.Parent.Vendor.Signal)
local Signals = require(script.Parent.Parent.Constants.Signals)
local GetAsync = require(script.Parent.Parent.Functions.GetAsync)
local Errors = require(script.Parent.Parent.Constants.Errors)
local DeepCopy = require(script.Parent.Parent.Functions.DeepCopy)

type Trove = typeof(Trove.new())
type Signal = typeof(Signal.new())

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model.PlayerAdded = nil :: Signal?
Model.PlayerRemoving = nil :: Signal?
Model._trove = nil :: Trove
Model._profiles = {} :: {[string]: Profile.Profile}
Model._schema = Schema.new({}) :: Schema.Schema
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

    self.PlayerAdded = Signal.new()
    self.PlayerRemoving = Signal.new()

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
        local success: boolean, result: any? = GetAsync(key, self._dataStore)

        if success then
            resolve(result)
        else
            reject(result)
        end
    end)
end

--[[
    Player Managed DataStore
    ====================
]]

--[=[
    Loads a player's profile

    @param player Player -- The player to load the profile for

    @return ()
]=]
function Model:_LoadProfile(player: Player): ()
    local key: string = player.UserId..self._options.savingKey

    self:_GetAsync(key):andThen(function(result: any?)
        -- Create player's profile
        self:_CreateProfile(player, result)
    end):catch(function()
        --kick the player
        player:Kick(Errors.RobloxServersDown)
    end)
end

--[=[
    Creates a player's profile inside of the cache of the Model

    @param player Player -- The player to create the profile for
    @param data any? -- The data to create the profile with

    @return ()
]=]
function Model:_CreateProfile(player: Player, data: any?): ()
    local firstTime: boolean = data == nil
    local profile: Profile.Profile = Profile.new()
    profile._Player = player

    if firstTime then
        local schemaCopy: {[string]: any} = DeepCopy(self._schema:Get())
        profile._data = schemaCopy
    else
        profile._data = data
    end

    self.PlayerAdded:Fire(player, profile, firstTime)
end

function Model:_UnloadProfile(player: Player): ()
    
end

function Model.__tostring(model: Model): string
    return model._name
end

export type Model = typeof(Model)

return Model