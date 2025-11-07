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
    }
end

function Circle:draw()
    if Current.mouse and Current.mouse.dead then
        love.graphics.setColor(1, 1, 1, 0.3)
    end
    love.graphics.circle("fill", self.x, self.y, self.r)
    ResetColor()
end

return Circle