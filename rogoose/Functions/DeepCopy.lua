--[[
    This function is used to create a deep copy of a table.
    This is useful for when you want to create a copy of a table without
    modifying the original table
]]
local function DeepCopy(tab)
    local copy = {}
    
    for k, v in pairs(tab) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
            setmetatable(copy[k], getmetatable(v))
        else
            copy[k] = v
        end
    end

    return copy
end

return DeepCopy