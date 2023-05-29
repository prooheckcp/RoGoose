--[=[
    Profiles consist of data containers to contain data for a specific player
    They are automatically managed by RoGoose allowing you to focus on what matters
]=]
local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"
Profile._Player = nil :: Player?
Profile._data = {} :: {[string]: any}
Profile._lastSave = tick() :: number
Profile._key = "" :: string

--[=[
    Creates a new instance of a Profile
]=]
function Profile.new(): Profile
    local self = setmetatable({}, Profile)
    self._data = {}

    return self
end

function Profile:Get<T>(index: string)
    
end

function Profile:Set<T>(index: string, value: T)

end

function Profile:AddElement<T>(index: string, value: T)

end

function Profile:RemoveElement<T>(index: string, value: T)

end

function Profile:Increment(index: string, value: number)

end

function Profile:Subtract(index: string, value: number)

end

export type Profile = typeof(Profile.new())

return Profile