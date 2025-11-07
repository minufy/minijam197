local On = Object:new()

function On:init(x, y, r)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = r
 
    self.tags = {
        on = true,
        mouse_col = true,
    }
end

function On:draw()
    if Current.on then
        love.graphics.setColor(Alpha(COLOR.HI, 0.8))
        if Current.mouse and Current.mouse.dead then
            love.graphics.setColor(Alpha(COLOR.HI, 0.2))
        end
        love.graphics.circle("fill", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
        ResetColor()
    else
        love.graphics.setColor(Alpha(COLOR.HI, 0.8))
        if Current.mouse and Current.mouse.dead then
            love.graphics.setColor(Alpha(COLOR.HI, 0.2))
        end
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
        ResetColor()
    end
end

return On