local Settings = require(script.Parent.Parent.Constants.Settings)

--[[
    This is a wrapper function for the DataStore:UpdateAsync() function

    @param key string -- The key to get from the DataStore
    @param dataStore DataStore -- The DataStore to get the key from

    @return (boolean, any) -- (success -> False means error from the server, value)
]]
local function GetAsync(key: string, dataStore: DataStore): (boolean, any?)
    local function getAttempt()
        return pcall(function()
                    return dataStore:UpdateAsync(key, function(oldValue: any?)
                        return oldValue
                    end)
                end)
    end

    local currentAttempts: number = 0
    local success: boolean, value: any = false, nil

    repeat
        currentAttempts += 1

        if currentAttempts > Settings.MaximumAttempts then
            return false, nil
        end

        success, value = getAttempt()
    until
        success

    return true, value
end

return GetAsync