--!strict

--[[
    Returns the veriable type of the value passed in.
    Works like typeof() but also supports dictionaries

    ```lua 
    local GetType = require(script.Parent.GetType)

    local myDictionary = {
        Hello = "World"
    }

    local myArray = {
        "Hello",
        "World"
    }

    local myString = "Hello World"

    print(GetType(myDictionary)) -- dictionary
    print(GetType(myArray)) -- table
    print(GetType(myString)) -- string
    ```

    @param value any

    @return string -- The type of the value passed in
]]
local function GetType(value: any): string
    local valueType: string = typeof(value)

    if valueType ~= "table" then
        return valueType
    end

    if value.type then -- Check for classes
        return value.type
    end

    if #value == 0 and next(value) ~= nil then -- Check for dictionaries
        return "dictionary"
    end

    return valueType -- Is a table but not a dictionary
end

return GetType