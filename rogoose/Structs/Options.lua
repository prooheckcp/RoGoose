--!strict
local ModelType = require(script.Parent.Parent.Enums.ModelType)

local Options = {}
Options.__index = Options

export type Options = {
    scope: string,
    options: Instance?,
    modelType: ModelType.ModelType,
}

function Options.new(options: Options?): Options
    options = (options or {}) :: Options

    assert(options)

    local _options = {
        scope = options.scope or "global",
        options = options.options or nil,
        modelType = options.modelType or ModelType.Player
    }

    return _options
end

return Options