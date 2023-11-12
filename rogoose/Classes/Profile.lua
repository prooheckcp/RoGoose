--!strict
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local Keys = require(script.Parent.Parent.Constants.Keys)
local GetNestedValue = require(script.Parent.Parent.Functions.GetNestedValue)
local Warning = require(script.Parent.Parent.Functions.Warning)
local Warnings = require(script.Parent.Parent.Constants.Warnings)
local GetType = require(script.Parent.Parent.Functions.GetType)
local AssertType = require(script.Parent.Parent.Functions.AssertType)
local Signal = require(script.Parent.Parent.Vendor.Signal)
local Signals = require(script.Parent.Parent.Constants.Signals)
local UpdateAsync = require(script.Parent.Parent.Functions.UpdateAsync)

local SessionLockStore = DataStoreService:GetDataStore(Keys.SessionLock)

--[=[
    Profiles consist of data containers to contain data for a specific player
    They are automatically managed by RoGoose allowing you to focus on what matters
]=]
local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"
Profile._player = nil :: Player?
Profile._data = {} :: {[string]: any}
Profile._lastSave = tick() :: number
Profile._key = "" :: string
Profile._pathSignals = {} :: {[string]: Signal.Signal<any, any>} -- Path to signal
Profile._dataStore = nil :: DataStore?

--[=[
    Creates a new instance of a Profile
]=]
function Profile.new(): Profile
    local self = setmetatable({}, Profile)
    self._key = ""
    self._player = nil :: Player?
    self._lastSave = tick()
    self._data = {}
    self._dataStore = nil :: DataStore?
    self._pathSignals = {}

    return self
end

--[=[
    Gets the player that the profile belongs to

    ```lua
    local player: Player = profile:GetPlayer()
    print(player.Name) -- Prints the player's name
    ```

    @return Player
]=]
function Profile:GetPlayer(): Player
    return self._player
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

    local gold: number = profile:Get("Gold")
    local yen: number = profile:Get("Wallet.Yen")

    print(gold) -- 5
    print(yen) -- 3
    ```

    @param path string -- The path to the data

    @return T -- T being whatever value type that you are getting
]=]
function Profile:Get<T>(path: string): T
    AssertType(path, "path", "string")

    local value: T, _, warningMessage: string? = GetNestedValue(self._data, path)

    if warningMessage then
        Warning(warningMessage)
    end

    return value
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

    local gold: number = profile:Get("Gold")
    local yen: number = profile:Get("Wallet.Yen")

    print(gold) -- 5
    print(yen) -- 3

    local previousGold: number = profile:Set("Gold", 10)
    local previousYen: number = profile:Set("Wallet.Yen", 5)

    print(previousGold) -- 5
    print(previousYen) -- 3

    print(profile:Get("Gold")) -- 10
    print(profile:Get("Wallet.Yen")) -- 5
    ```

    @param path string -- The path to the data
    @param newValue T -- The new value to set

    @return T -- The previous value that was set
]=]
function Profile:Set<T>(path: string, newValue: T): T?
    AssertType(path, "path", "string")

    local oldValue: T, outterScore: {[string]: any}, warningMessage: string? = GetNestedValue(self._data, path)
    local strings: {string} = string.split(path, ".")
    local lastIndex: string = strings[#strings]

    if warningMessage then
        Warning(warningMessage)
        return nil
    end

    if GetType(newValue) ~= GetType(oldValue) then
        warn(Warnings.ChangeWrongType.." from type "..GetType(oldValue).." to type "..GetType(newValue))
        return nil
    end

    outterScore[lastIndex] = newValue

    if self._pathSignals[path] then
        self._pathSignals[path]:Fire(newValue, oldValue)
    end

    return oldValue
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

    local inventory: {Name: string, Damage: number} = profile:Get("Inventory")

    print(inventory[1].Name) -- Sword

    profile:AddElement("Inventory", {
        Name = "Shield",
        Defense = 5
    })

    print(inventory[2].Name) -- Shield
    ```

    @param path string -- The path to the data
    @param value T -- The value to add

    @return any -- The array that the value was added to
]=]
function Profile:AddElement<T>(path: string, value: T): any
    AssertType(path, "path", "string")

    local array: any, _, warningMessage: string? = GetNestedValue(self._data, path)

    if warningMessage then
        Warning(warningMessage)
        return
    end

    if GetType(array) ~= "table" then
        Warning("Can only add elements to tables")
        return
    end

    table.insert(array, value)

    return array
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
    
    local inventory: {Name: string, Damage: number} = profile:Get("Inventory")

    print(inventory[1].Name) -- Sword

    profile:RemoveElementByIndex("Inventory", 1) -- Removes the first element in the array

    print(inventory[1].Name) -- Shield
    ```

    @param path string -- The path to the data
    @param arrayIndex number -- The index of the array to remove

    @return any -- The array that the value was removed from
]=]
function Profile:RemoveElementByIndex<T>(path: string, arrayIndex: any): any
    AssertType(path, "path", "string")

    local array: any, _, warningMessage: string? = GetNestedValue(self._data, path)

    if warningMessage then
        Warning(warningMessage)
    end

    local objectType: string = GetType(array)

    if objectType ~= "table" and objectType ~= "dictionary" then
        Warning("Can only add elements to tables")
        return
    end

    if objectType == "dictionary" then
        for key: any in array do
            if key ~= arrayIndex then
                continue
            end
    
            array[key] = nil
            break
        end
    elseif objectType == "table" then
        AssertType(arrayIndex, "arrayIndex", "number")

        if #array >= arrayIndex then
            table.remove(array, arrayIndex)
        end
    end

    return array
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

    local yenExists: boolean = profile:Exists("Wallet.Yen")

    print(exists) -- true

    local goldExists: boolean = profile:Exists("Wallet.Gold")

    print(goldExists) -- false
    ```

    @param index string -- The path to the data

    @return boolean -- Whether or not the value exists
]=]
function Profile:Exists(path: string): boolean
    AssertType(path, "path", "string")

    local value: any = GetNestedValue(self._data, path)

    return value ~= nil
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

    local previousGold: number, currentGold: number = profile:Increment("Gold", 2)

    print(previousGold) -- 5
    print(currentGold) -- 7
    ```

    @param index string -- The path to the data
    @param amount number -- The amount to subtract

    @return number, number -- The previous value and the new value
]=]
function Profile:Increment(path: string, amount: number): (number, number)
    AssertType(path, "path", "string")
    AssertType(amount, "amount", "number")

    local currentValue: any = self:Get(path)

    if GetType(currentValue) ~= "number" then
        warn(Warnings.NumberWrongType)
        return 0, 0
    end

    self:Set(path, currentValue + amount)

    return currentValue, self:Get(path)
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

    local previousGold: number, currentGold: number = profile:Subtract("Gold", 2)

    print(previousGold) -- 5
    print(currentGold) -- 3
    ```

    @param path string -- The path to the data
    @param amount number -- The amount to subtract

    @return number, number -- The previous value and the new value
]=]
function Profile:Subtract(path: string, amount: number): (number, number)
    AssertType(path, "path", "string")
    AssertType(amount, "amount", "number")
    
    local currentValue: any = self:Get(path)

    if GetType(currentValue) ~= "number" then
        warn(Warnings.NumberWrongType)
        return 0, 0
    end

    self:Set(path, currentValue - amount)

    return currentValue, self:Get(path)
end

--[=[
    Listens to input changes on the given path. This will return a signal that will fire whenever the value at the given path changes.

    E.g
    ```lua
    Currencies.PlayerAdded:Connect(function(player: Player, data: RoGoose.Profile, firstTime: boolean)
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player

        local gold = Instance.new("IntValue")
        gold.Name = "💸Gold"
        gold.Value = data:Get("Gold")
        gold.Parent = leaderstats

        data:GetDataChangedSignal("Gold"):Connect(function(newGold: number, oldGold: number)
            gold.Value = newGold
        end)
    end)
    ```

    @param path string -- The path to the data

    @return Signal.Signal<(any) -> nil> -- The signal that will fire whenever the value at the given path changes
]=]
function Profile:GetDataChangedSignal(path: string): Signal.Signal<any, any>
    AssertType(path, "path", "string")

    if not self._pathSignals[path] then
        self._pathSignals[path] = Signal.new()
    end

    local newSignal: Signal.Signal<any, any> = Signal.new()

    self._pathSignals[path]:Connect(function(newValue: any, oldValue: any)
        newSignal:Fire(newValue, oldValue)
    end)

    return newSignal
end

--[=[
    Updates the profile with the given data. This will overwrite the current data in the DataStore

    ```lua
    local profile: Profile.Profile? = model:GetProfile(player)

    if profile then
        profile:Save() -- Saved on the DataStore!
    end
    ```

    @return boolean, any? -- Whether or not the save was successful and the new value
]=]
function Profile:Save(): (boolean, any?)
    local processId: string = HttpService:GenerateGUID(false)
    Signals.AddTask:Fire(processId)
    
    local success: boolean, newValue: any = UpdateAsync(self._key, self._data, self._dataStore)

    if success then
        self._lastSave = os.time()
    end

    Signals.ClearTask:Fire(processId)

    return success, newValue
end

--[=[
    Locks the profile. This will make it so that this profile cannot be loaded until it gets released.
    This is useful for when you want to make sure that the profile is not loaded multiple times.

    -- Don't use if you don't know what you are doing

    @return boolean, number
]=]
function Profile:Lock(): (boolean, number)
    return UpdateAsync(self._key, true, SessionLockStore)
end

--[=[
    Releases the profile. This will make it so that this profile can be loaded again.

    -- Don't use if you don't know what you are doing

    @return 
]=]
function Profile:Release(): (boolean, number)
    return UpdateAsync(self._key, false, SessionLockStore)
end

export type Profile = typeof(Profile.new())

return Profile