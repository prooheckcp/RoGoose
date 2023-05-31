--!strict
local GetType = require(script.Parent.GetType)

--[[
    Uses the `assert` function to check if a variable's type is equal to the expected type the variable has to be.
    This is used so it errors if an incorrect type was used for a variable.
    This is important to establish a barrier therefore the internals work as expected.

    @param variable any
    @param variableName string
    @param expectedType string

    @return ()
]]
local function AssertType(variable: any, variableName: string, expectedType: string)
    local calledFrom: string = debug.traceback(nil, 3)
    assert(GetType(variable) == expectedType, `{calledFrom}{variableName} must be a {expectedType}; got {GetType(variable)}`)
end

return AssertType
