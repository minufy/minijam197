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
    love.graphics.setColor(COLOR.LIGHT)
    if Current.mouse.dead then
        local s = "restart"
        love.graphics.print(s, self.x-Font:getWidth(s)/2, self.y-20)
    end
    love.graphics.circle("fill", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
    ResetColor()
end

return Start