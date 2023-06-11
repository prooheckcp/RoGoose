local RunService = game:GetService("RunService")

local Warnings = require(script.Parent.Parent.Constants.Warnings)
local Settings = require(script.Parent.Parent.Constants.Settings)

--[[    
    Warning wrapper for the RoGoose library

    @param message string -- The message to warn

    @return ()
]]
local function Warning(message: string): ()
    if RunService:IsStudio() then
        if Settings.OutputWarningsInStudio then
            warn(Warnings.Header..message)
        end
        return
    end
    
    if Settings.OutputWarningsInRelease then
        warn(Warnings.Header..message)
    end
end

return Warning