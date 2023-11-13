--[[
    Gets a nested value from a table

    @param data {[string]: any} -- The table to get the value from
    @param path string -- The path to the value

    @return (any, {[string]: any}, string?, string) -- Returns: value|outterTable|errorMessage|lastIndex
]]
local function GetNestedValue(data: {[string]: any}, path: string): (any, {[string]: any}, string?, string)
	local indexes: {string} = string.split(path, ".")
	local lastTable: {[string]: any} = data
	
	for i = 1, #indexes do
		local currentIndex: string = indexes[i]
		local lastIndex: string = i == 1 and "schema" or indexes[i - 1]
		local currentValue: any = lastTable[currentIndex]
		
		if currentValue == nil then
			return nil, lastTable, currentIndex.." is not a valid member of "..lastIndex, currentIndex
		end
		
		if i == #indexes then
			return currentValue, lastTable, nil, currentIndex
		else
			lastTable = currentValue
		end
	end

    return nil, lastTable, nil, "" -- Didn't find anything
end

return GetNestedValue