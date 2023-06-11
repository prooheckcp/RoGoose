local KeyType = require(script.Parent.Parent.Functions.KeyType)

--[=[
    Gets the key used for the DataStore
    
    @param key Player | string
    @param dataStoreName string

    @return string
]=]
local function GetKey(key: Player | string, dataStoreName: string): string
    local _key: string = KeyType(key)

    if _key == "Player" then
        return dataStoreName..tostring((key :: Player).UserId)
    elseif _key == "string" then
        return dataStoreName..key :: string
    end

    return ""
end

return GetKey