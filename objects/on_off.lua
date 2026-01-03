local OnOff = Object:new()

function OnOff:init(x, y, r, is_on)
    self.x = x
    self.y = y
    self.w = 0
    self.h = 0
    self.r = r
 
    self.is_on = is_on

    self.tags = {
        on_off = true,
        mouse_col = true,
        editor_col = true,
    }
end

function OnOff:update(dt)
    if Game.on == self.is_on then
        self.tags.mouse_col = true
    else
        self.tags.mouse_col = false
    end
end

function OnOff:draw()
    if Game.on == self.is_on then
        love.graphics.setColor(Alpha(COLOR.HI, 0.8))
        if Game.mouse and Game.mouse.dead then
            love.graphics.setColor(Alpha(COLOR.HI, 0.2))
        end
        love.graphics.circle("fill", self.x, self.y, self.r+BreathingEffect())
        ResetColor()
    else
        love.graphics.setColor(Alpha(COLOR.HI, 0.8))
        if Game.mouse and Game.mouse.dead then
            love.graphics.setColor(Alpha(COLOR.HI, 0.2))
        end
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", self.x, self.y, self.r+BreathingEffect())
        ResetColor()
    end
end

return OnOff