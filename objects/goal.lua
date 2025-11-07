local Goal = Object:new()

function Goal:init(x, y, r)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = 10

    self.tags = {
        goal = true,
        mouse_col = true,
    }
end

function Goal:draw()
    love.graphics.setColor(0, 0, 1, 0.4)
    love.graphics.circle("fill", self.x, self.y, self.r)
    ResetColor()
end

return Goal