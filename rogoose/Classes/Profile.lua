--[=[
    Profiles consist of data containers to contain data for a specific player
    They are automatically managed by RoGoose allowing you to focus on what matters
]=]
local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"
Profile._Player = nil :: Player?
Profile._data = {}

--[=[
    Creates a new instance of a Profile
]=]
function Profile.new(): Profile
    local self = setmetatable({}, Profile)
    self._data = {}

    return self
end

function Profile.__tostring(profile: Profile)
    return tostring(profile._data)
end

export type Profile = typeof(Profile.new())

return Profile