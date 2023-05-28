local Settings = require(script.Parent.Parent.Constants.Settings)

--[[
    Proxy to properly update a data store with the new data    

    @param key string
    @param newValue any
    @param dataStore DataStore

    @return nil
]]
local function UpdateAsync(key: string, newValue: any, dataStore: DataStore): (boolean, any)
    local function updateAttempt(): (boolean, any?)
        return pcall(function()
            return dataStore:UpdateAsync(key, function()
                return newValue
            end)
        end)
    end

    local tries: number = 0
    local success: boolean, value: any
    repeat
        tries += 1
        success, value = updateAttempt()

        if success then
            break
        end
    until
        tries > Settings.MaximumAttempts

    return success, value
end

return UpdateAsync