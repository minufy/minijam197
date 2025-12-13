local Circle = Object:new()

function Circle:init(x, y, r)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = r

    self.tags = {
        circle = true,
        mouse_col = true,
        editor_col = true,
    }
end

function Circle:draw()
    love.graphics.setColor(Alpha(COLOR.HI, 0.9))
    if Current.mouse and Current.mouse.dead then
        love.graphics.setColor(Alpha(COLOR.HI, 0.3))
    end
    love.graphics.circle("fill", self.x, self.y, self.r+BreathingEffect())
    ResetColor()
end

return Circle