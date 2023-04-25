--!strict

local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"

function Profile.new(): Profile
    local self = setmetatable({}, Profile)

    return self
end

export type Profile = typeof(Profile.new())

return Profile