--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

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
local AssertSchema = require(script.Parent.Parent.Functions.AssertSchema)
local UpdateAsync = require(script.Parent.Parent.Functions.UpdateAsync)
local KeyType = require(script.Parent.Parent.Functions.KeyType)
local Warning = require(script.Parent.Parent.Functions.Warning)
local Warnings = require(script.Parent.Parent.Constants.Warnings)
local AssertModelType = require(script.Parent.Parent.Functions.AssertModelType)

type Trove = typeof(Trove.new())

local Model = {}
Model.__index = Model
Model.type = "DatabaseModel"
Model.PlayerAdded = nil :: Signal.Signal<Player, {[string]: any}, boolean>?
Model.PlayerRemoving = nil :: Signal.Signal<Player, {[string]: any}>?
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

--[=[
    Gets the data with the given index from the profile

    ```lua
    --[[
        Imagine the following schema
        {
            Gold = 5,
            Wallet = {
                Yen = 3
            }
        }
    ]]

    local gold: number = model:Get("MyModelKey", "Gold")
    local yen: number = model:Get("MyModelKey", "Wallet.Yen")

    print(gold) -- 5
    print(yen) -- 3
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data

    @return T -- T being whatever value type that you are getting
]=]
function Model:Get<T>(key: string | Player, index: string): T?
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return nil end

        profile:Get(index)
    else
        
    end
end

--[=[
    Sets a players profile value into a new value. It also returns the previous value
    that is had before it was set

    ```lua
    --[[
        Imagine the following schema
        {
            Gold = 5,
            Wallet = {
                Yen = 3
            }
        }
    ]]

    local gold: number = model:Get("MyModelKey", "Gold")
    local yen: number = model:Get("MyModelKey", "Wallet.Yen")

    print(gold) -- 5
    print(yen) -- 3

    local previousGold: number = model:Set("MyModelKey", "Gold", 10)
    local previousYen: number = model:Set("MyModelKey", "Wallet.Yen", 5)

    print(previousGold) -- 5
    print(previousYen) -- 3

    print(model:Get("MyModelKey", "Gold")) -- 10
    print(model:Get("MyModelKey", "Wallet.Yen")) -- 5
    ```

    @param key string | Player -- The key to set the data to
    @param index string -- The path to the data
    @param newValue T -- The new value to set

    @return T -- The previous value that was set
]=]
function Model:Set<T>(key: string | Player, index: string, newValue: T): T?
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return nil end

        profile:Set(index, newValue)
    else

    end
end

--[=[
    Adds an element to an array in the given index

    ```lua
    --[[
        Imagine the following schema
        {
            Gold = 5,
            Inventory = {
                {
                    Name = "Sword",
                    Damage = 5
                },
            }
        }
    ]]

    local inventory: {Name: string, Damage: number} = model:Get("MyModelKey", "Inventory")

    print(inventory[1].Name) -- Sword

    model:AddElement("MyModelKey", "Inventory", {
        Name = "Shield",
        Defense = 5
    })

    print(inventory[2].Name) -- Shield
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data
    @param value T -- The value to add

    @return any -- The array that the value was added to
]=]
function Model:AddElement<T>(key: string | Player, index: string, value: T): any
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return nil end

        profile:AddElement(index, value)
    else

    end
end

--[=[
    Removes an element from an array in the given index by the given array index

    ```lua

    --[[
        Imagine the following schema
        {
            Gold = 5,
            Inventory = {
                {
                    Name = "Sword",
                    Damage = 5
                },
                {
                    Name = "Shield",
                    Defense = 5
                }
            }
        }
    ]]
    
    local inventory: {Name: string, Damage: number} = model:Get("MyModelKey", "Inventory")

    print(inventory[1].Name) -- Sword

    model:RemoveElementByIndex("MyModelKey", "Inventory", 1) -- Removes the first element in the array

    print(inventory[1].Name) -- Shield
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data
    @param arrayIndex number -- The index of the array to remove

    @return any -- The array that the value was removed from
]=]
function Model:RemoveElementByIndex<T>(key: string | Player, index: string, arrayIndex: any): any
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return nil end

        profile:RemoveElementByIndex(index, arrayIndex)
    else

    end
end

--[=[
    Will return whether or not the given value exists within the player's profile

    
    ```lua
    --[[
        Imagine the following schema
        {
            Gold = 5,
            Wallet = {
                Yen = 3
            }
        }
    ]]

    local yenExists: boolean = model:Exists("MyModelKey", "Wallet.Yen")

    print(exists) -- true

    local goldExists: boolean = model:Exists("MyModelKey", "Wallet.Gold")

    print(goldExists) -- false
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data

    @return boolean -- Whether or not the value exists
]=]
function Model:Exists(key: string | Player, index: string): boolean
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return false end

        profile:Exists(index)
    else

    end
end

--[=[
    Increments the number value at the given index by the given amount. It will
    also return the previous value (before incrementing) and the new value (after incrementing)

    ```lua

    --[[
        Imagine the following schema
        {
            Gold = 5,
            Wallet = {
                Yen = 3
            }
        }
    ]]

    local previousGold: number, currentGold: number = model:Increment("MyModelKey", "Gold", 2)

    print(previousGold) -- 5
    print(currentGold) -- 7
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data
    @param amount number -- The amount to subtract

    @return number, number -- The previous value and the new value
]=]
function Model:Increment(key: string | Player, index: string, amount: number): (number, number)
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return 0, 0 end

        profile:Increment(index, amount)
    else

    end
end

--[=[
    Subtracts the number value at the given index by the given amount. It will
    also return the previous value (before subtracting) and the new value (after subtracting)

    ```lua

    --[[
        Imagine the following schema
        {
            Gold = 5,
            Wallet = {
                Yen = 3
            }
        }
    ]]

    local previousGold: number, currentGold: number = model:Subtract("MyModelKey", "Gold", 2)

    print(previousGold) -- 5
    print(currentGold) -- 3
    ```

    @param key string | Player -- The key to get the data from
    @param index string -- The path to the data
    @param amount number -- The amount to subtract

    @return number, number -- The previous value and the new value
]=]
function Model:Subtract(key: string | Player, index: string, amount: number): (number, number)
    if KeyType(key) == "Player" then
        local profile: Profile.Profile = self:GetProfile(key)

        if profile == nil then return 0, 0 end

        profile:Subtract(index, amount)
    else

    end
end

--[=[
    Gets a player's profile. If it returns nil it means that the player left the game

    @yield
    @param player Player -- The player to get the profile for

    @return Profile
]=]
function Model:GetProfile(player: Player): Profile.Profile?
    AssertModelType(self._modelType, ModelType.Player)
    
    local profile: Profile.Profile?

    repeat
        profile = self._profiles[player.UserId..self._options.savingKey]
        
        if not profile then
            task.wait()
        end
    until
        profile ~= nil or not Players:GetPlayerByUserId(player.UserId)

    if profile == nil then
        Warning(Warnings.PlayerIsNotInTheSocket)
    end

    return profile
end

--[=[
    Saves all the currently loaded profiles for this module. It will fail
    if you attempt to call it on a model that doesn't specifically work for players 

    @return ()
]=]
function Model:SaveAllProfiles(): ()
    AssertModelType(self._modelType, ModelType.Player)

    for _, profile: Profile.Profile in self._profiles do
        profile:Save()
    end
end

--[=[
    Saves a player's profile

    @private

    @param player Player -- The player to save the profile for

    @return boolean, any -- Whether or not the save was successful and the error if it wasn't
]=]
function Model:SaveProfile(player: Player): (boolean, any?)
    local profile: Profile.Profile? = self:GetProfile(player)

    if not profile then
        return false, nil
    end

    return profile:Save()
end

--[=[
    Gets async from the DataStore with the given key

    @private

    @param key string -- The key to get the data from

    @return Promise
]=]
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
        self:_CreateProfile(player, result, key)
    end, function()
        --kick the player
        player:Kick(Errors.RobloxServersDown)
    end)
end

--[=[
    Creates a player's profile inside of the cache of the Model

    @private

    @param player Player -- The player to create the profile for
    @param data any? -- The data to create the profile with

    @return ()
]=]
function Model:_CreateProfile(player: Player, data: any?, key: string): ()
    local firstTime: boolean = data == nil
    local profile: Profile.Profile = Profile.new()
    profile._key = key
    profile._Player = player

    if firstTime then
        local schemaCopy: {[string]: any} = DeepCopy(self._schema:Get())
        profile._data = schemaCopy
    else
        profile._data = AssertSchema(self._schema:Get(), data)
    end

    self._profiles[key] = profile
    self.PlayerAdded:Fire(player, profile, firstTime)
end

--[=[
    Unloads a player's profile

    @private

    @param player Player -- The player to unload the profile for

    @return ()
]=]
function Model:_UnloadProfile(player: Player): ()
    local profile: Profile.Profile? = self:GetProfile(player)

    if not profile then
        return
    end

    self:SaveProfile(player)
    self._profiles[profile._key] = nil
end

function Model.__tostring(model: Model): string
    return model._name
end

export type Model = typeof(Model)

return Model