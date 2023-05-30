local GetNestedValue = require(script.Parent.Parent.Functions.GetNestedValue)
local Warning = require(script.Parent.Parent.Functions.Warning)
local Warnings = require(script.Parent.Parent.Constants.Warnings)

--[=[
    Profiles consist of data containers to contain data for a specific player
    They are automatically managed by RoGoose allowing you to focus on what matters
]=]
local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"
Profile._Player = nil :: Player?
Profile._data = {} :: {[string]: any}
Profile._lastSave = tick() :: number
Profile._key = "" :: string

--[=[
    Creates a new instance of a Profile
]=]
function Profile.new(): Profile
    local self = setmetatable({}, Profile)
    self._data = {}

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
    return self._Player
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

    @param index string -- The path to the data

    @return T -- T being whatever value type that you are getting
]=]
function Profile:Get<T>(index: string): T
    local value: T, _, warningMessage: string? = GetNestedValue(self._data, index)

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

    @param index string -- The path to the data
    @param newValue T -- The new value to set

    @return T -- The previous value that was set
]=]
function Profile:Set<T>(index: string, newValue: T): T
    local oldValue: T, outterScore: {[string]: any}, warningMessage: string? = GetNestedValue(self._data, index)
    local strings: {string} = string.split(index, ".")
    local lastIndex: string = strings[#strings]

    if warningMessage then
        Warning(warningMessage)
    end

    outterScore[lastIndex] = newValue

    return oldValue
end

function Profile:AddElement<T>(index: string, value: T)

end

function Profile:RemoveElement<T>(index: string, value: T)

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
function Profile:Exists(index: string): boolean
    local value: any = GetNestedValue(self._data, index)

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
function Profile:Increment(index: string, amount: number): (number, number)
    local currentValue: any = self:Get(index)

    if typeof(currentValue) ~= "number" then
        warn(Warnings.NumberWrongType)
        return 0, 0
    end

    self:Set(index, currentValue + amount)

    return currentValue, self:Get(index)
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

    @param index string -- The path to the data
    @param amount number -- The amount to subtract

    @return number, number -- The previous value and the new value
]=]
function Profile:Subtract(index: string, amount: number): (number, number)
    local currentValue: any = self:Get(index)

    if typeof(currentValue) ~= "number" then
        warn(Warnings.NumberWrongType)
        return 0, 0
    end

    self:Set(index, currentValue - amount)

    return currentValue, self:Get(index)
end

export type Profile = typeof(Profile.new())

return Profile