local On = Object:new()

local OnOff = require("objects.on_off")

function On:init(x, y, r)
    self.tags = {}
    
    Current:add(OnOff, x, y, r, true)
end

return On