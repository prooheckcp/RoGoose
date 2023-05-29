local GetNestedValue = require(script.Parent.Parent.Functions.GetNestedValue)

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
]=
]=]
function Profile:Get<T>(index: string)
    GetNestedValue(self._data, index)
end

function Profile:Set<T>(index: string, value: T)

end

function Profile:AddElement<T>(index: string, value: T)

end

function Profile:RemoveElement<T>(index: string, value: T)

end

function Profile:Exists(index: string): boolean

end

function Profile:Increment(index: string, value: number)

end

function Profile:Subtract(index: string, value: number)

end

export type Profile = typeof(Profile.new())

return Profile