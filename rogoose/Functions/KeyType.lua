--[[
    Returns the type of key that was passed in

    @private

    @param input string | Player -- The key to get the type of

    @return "Player" | "string"
]]
local function KeyType(input: string | Player): "Player" | "string"
    if typeof(input) == "Instance" and input:IsA("Player") then
        return "Player"
    end

    return "string"
end

return KeyType