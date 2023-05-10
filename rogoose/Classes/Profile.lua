local Profile = {}
Profile.__index = Profile
Profile.type = "DatabaseProfile"
Profile._data = {}

function Profile.new(): Profile
    local self = setmetatable({}, Profile)
    self._data = {}

    return self
end

--[=[

]=]
function Profile:ForceSave()
    
end

function Profile:Get<T>(index: string): T
    
end

function Profile:Set<T>(index: string, newValue: T): T

end

function Profile:Increment(index: string, value: number)
    
end

function Profile:Subtract(index: string, value: number): number
    
end

function Profile.__tostring(profile: Profile)
    return tostring(profile._data)
end

export type Profile = typeof(Profile.new())

return Profile