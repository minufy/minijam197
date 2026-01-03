local On = Object:new()

local OnOff = require("objects.on_off")

function On:init(x, y, r)
    self.tags = {}
    Game:add(OnOff, x, y, r, true)
    self.remove = true
end

return On