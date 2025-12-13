local RotateCCW = Object:new()

local Rotate = require("objects.rotate")

function RotateCCW:init(x, y, r)
    self.remove = true
    Current:add(Rotate, x, y, r, -1)
    self.tags = {}
end

return RotateCCW