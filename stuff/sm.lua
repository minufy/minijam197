SM = {}

function SM:init(name)
    self.current = require("scenes."..name)
    self.current:init()
end

function SM:update(dt)
    self.current:update(dt)
end

function SM:draw()
    self.current:draw()
end