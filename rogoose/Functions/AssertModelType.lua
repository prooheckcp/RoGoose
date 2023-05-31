--!strict
local ModelType = require(script.Parent.Parent.Enums.ModelType)

--[[
    Asserts that the model type is correct

    @return ()
]]
local function AssertModelType(modelType: ModelType.ModelType, expectedModelType: ModelType.ModelType)
    local calledFrom: string = debug.traceback(nil, 2)

    assert(modelType == expectedModelType, `{calledFrom}Attempted to use a {modelType} function in a {expectedModelType} model!`)
end

return AssertModelType
