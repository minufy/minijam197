local Rotate = Object:new()

local base_speed = 2

function Rotate:init(x, y, r, dir)
    self.center_x = x
    self.center_y = y
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    self.old_r = r
    self.r = r/3
    self.dir = dir

    self.tags = {
        circle = true,
        rotate = true,
        mouse_col = true,
        editor_col = true,
    }
end

function Rotate:update(dt)
    self.x = math.cos(self.dir*Current.timer/self.old_r*base_speed)*self.old_r+self.center_x
    self.y = math.sin(self.dir*Current.timer/self.old_r*base_speed)*self.old_r+self.center_y
end

function Rotate:draw()
    love.graphics.setColor(COLOR.HI)
    if Current.mouse and Current.mouse.dead then
        love.graphics.setColor(Alpha(COLOR.HI, 0.3))
    end
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", self.center_x, self.center_y, 2+BreathingEffect())
    love.graphics.circle("fill", self.x, self.y, self.r+BreathingEffect())
    ResetColor()
end

return Rotate