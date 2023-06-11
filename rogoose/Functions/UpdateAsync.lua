local Settings = require(script.Parent.Parent.Constants.Settings)

--[[
    Proxy to properly update a data store with the new data    

    @param key string
    @param newValue any
    @param dataStore DataStore

    @return boolean, any -- success, new value
]]
local function UpdateAsync(key: string, newValue: any, dataStore: DataStore, transformFunction: (any, DataStoreKeyInfo) -> (any, {number}?, {  }?)?): (boolean, any)
    local function updateAttempt(): (boolean, any?)
        return pcall(function()
            return dataStore:UpdateAsync(key, transformFunction or function()
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