local Rotate = Object:new()

local speed = 1.5

function Rotate:init(x, y, r)
    self.cx = x
    self.cy = y
    self.cr = r
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    self.r = r/2
    self.dir = 1
    if self.r > 20 then
        self.dir = -1
    end

    self.tags = {
        circle = true,
        rotate = true,
        mouse_col = true,
    }
end

function Rotate:update(dt)
    self.x = math.cos(self.dir*Current.timer/self.r*speed)*self.cr+self.cx
    self.y = math.sin(self.dir*Current.timer/self.r*speed)*self.cr+self.cy
end

function Rotate:draw()
    love.graphics.setColor(COLOR.HI)
    if Current.mouse and Current.mouse.dead then
        love.graphics.setColor(Alpha(COLOR.HI, 0.3))
    end
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", self.cx, self.cy, 2+math.sin(love.timer.getTime()*2)*0.3)
    love.graphics.circle("fill", self.x, self.y, self.r+math.sin(love.timer.getTime()*2)*0.3)
    ResetColor()
end

return Rotate