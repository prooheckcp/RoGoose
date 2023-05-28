local DeepCopy = require(script.Parent.DeepCopy)

--[[
    Asserts that the users data matches the schema

    @param schema {[string]: any} -- The schema that will represent your model
    @param userData {[string]: any} -- The data that the user has

    @return {[string]: any}
]]
local function AssertSchema(schema, userData): {[string]: any}
    for key: string, value: any in schema do
        local userValue: any? = userData[key]

        if typeof(userValue) ~= typeof(value) then
            if typeof(value) == "table" then
                userData[key] = DeepCopy(value)
            else
                userData[key] = value
            end
        end

        if typeof(value) == "table" then
            AssertSchema(value, userValue)
        end
    end

    return userData
end

return AssertSchema