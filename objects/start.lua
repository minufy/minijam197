local Start = Object:new()

function Start:init(x, y, r)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = 6

    self.tags = {
        start = true,
        mouse_col = true,
    }
end

function Start:draw()
    love.graphics.setColor(Alpha(COLOR.LIGHT), 0.4)
    love.graphics.circle("fill", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
    ResetColor()
end

return Start