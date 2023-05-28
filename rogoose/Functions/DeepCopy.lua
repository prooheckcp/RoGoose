local function DeepCopy(tab)
    local copy = {}
    
    for k, v in pairs(tab) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
            setmetatable(copy[k], getmetatable(v))
        else
            copy[k] = v
        end
    end

    return copy
end

return DeepCopy