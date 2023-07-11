local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)

local GlobalCounter: RoGoose.Model = RoGoose:GetModelAsync("GlobalCounter")

GlobalCounter:ReleaseProfile("Test")
local profile: RoGoose.Profile? = GlobalCounter:LoadProfile("Test")

if not profile then
    return
end


local function printCounter()
    print("Global Counter:", profile:Get("GlobalCounter"), profile:Get("BannedPlayers"))
end

profile:Lock()

print("Initial")
printCounter()
print("==Increment==")
profile:Increment("GlobalCounter", 1)
printCounter()
print("==SET==")
profile:Set("GlobalCounter", 5)
printCounter()
print("==Subtract==")
profile:Subtract("GlobalCounter", 1)
printCounter()
print("==Exists==")
print(profile:Exists("BannedPlayers"))
print("==AddElement==")
profile:AddElement("BannedPlayers", "World")
printCounter()
print("==RemoveElement==")
profile:RemoveElementByIndex("BannedPlayers", 2)
printCounter()