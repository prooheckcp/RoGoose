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

--[=[
    Proxy for Profile.new()
    Used to clone Mongoose's syntax https://mongoosejs.com/docs/models.html

    @return Profile
]=]
function Profile.create(): Profile
    return Profile.new()
end

--[=[

]=]
function Profile:ForceSave()
    
end

function Profile:Find<T>(index: string): T
    
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