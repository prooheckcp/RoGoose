local Signal = require(script.Parent.Parent.Vendor.Signal)

return {
    ModelCreated = Signal.new(),
    AddTask = Signal.new(),
    ClearTask = Signal.new(),
}