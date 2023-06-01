local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoGoose = require(ReplicatedStorage.RoGoose)
local ModelLoader = require(ServerScriptService.Server.ModelLoader)
local UnitTestsConstants = require(ServerScriptService.Server.UnitTestsConstants.Player)

return function()
    local player: Player = UnitTestsConstants.Player
    local profile: RoGoose.Profile = ModelLoader.Currencies:GetProfile(player)
    
    describe("GetPlayer", function()
        it("should return an instance", function()
            expect(typeof(profile:GetPlayer()) == "Instance").to.be.ok()
        end)

        it("should equal to a player instance", function()
            expect(profile:GetPlayer():IsA("Player")).to.be.ok()
        end)
    end)

    describe("Get", function()
        it("should return nil with wrong index", function()
            expect(profile:Get("wrong") == nil).to.be.ok()
        end)

        it("should return a number with right type", function()
            expect(typeof(profile:Get("Gold")) == "number").to.be.ok()
        end)

        it("should error with wrong input", function()
            expect(function()
                profile:Get(1)
            end).to.throw()
        end)

        it("should return nested values correctly", function()
            local yen = profile:Get("Wallet.Yen")
            
            expect(yen ~= nil).to.be.ok()
        end)
    end)
end