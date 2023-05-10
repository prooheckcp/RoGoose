--!strict
local DefaultSettings = require(script.Parent.Parent.Constants.DefaultSettings)

local function GeneratePlayerKey(player: Player)
    return tostring(player.UserId)..DefaultSettings.Key
end

return GeneratePlayerKey