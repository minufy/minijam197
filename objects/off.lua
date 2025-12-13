local Off = Object:new()

local OnOff = require("objects.on_off")

function Off:init(x, y, r)
    self.tags = {}

    Current:add(OnOff, x, y, r, false)
end

return Off