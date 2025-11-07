local Goal = Object:new()

function Goal:init(x, y, r)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = 6

    self.tags = {
        goal = true,
        mouse_col = true,
    }
end

function Goal:draw()
    love.graphics.setColor(Alpha(COLOR.LIGHT, 0.8))
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
    ResetColor()
end

return Goal