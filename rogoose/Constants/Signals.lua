local Signal = require(script.Parent.Parent.Vendor.Signal)
local Model = require(script.Parent.Parent.Classes.Model)

return {
    ModelCreated = Signal.new() :: Signal.Signal<Model.Model>,
}