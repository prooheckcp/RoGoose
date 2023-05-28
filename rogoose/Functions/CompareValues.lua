--!strict
local GetType = require(script.Parent.GetType)

--[[
    Compares two types to make sure if they are the same
]]
local function CompareValues(value1: any?, value2: any?): boolean
    return GetType(value1) == GetType(value2)
end

return CompareValues