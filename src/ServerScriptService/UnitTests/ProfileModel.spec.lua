local ServerScriptService = game:GetService("ServerScriptService")

local ModelLoader = require(ServerScriptService.Server.ModelLoader)
local UnitTestsConstants = require(ServerScriptService.Server.UnitTestsConstants.Player)

return function()
    describe("greet", function()
        it("should include the customary English greeting", function()
            local profile: RoGoose.Profile = ModelLoader.Currencies:GetProfile(player)
            expect(true).to.be.ok()
        end)

        it("should include the person being greeted", function()
            expect(false).to.be.ok()
        end)
    end)
end