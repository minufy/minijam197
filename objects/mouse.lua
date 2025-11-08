local Mouse = Object:new()
local Particle = require("objects.particle")

local damp = 0.9

function Mouse:init()
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0

    self.r = 10
    self.type = "circle"

    self.tags = {
        mouse = true,
    }
end

function Mouse:update(dt)
    self.x = self.x+(Res:getX()-self.x)*damp*dt
    self.y = self.y+(Res:getY()-self.y)*damp*dt
    
    local x = math.floor(Res:getX())
    local y = math.floor(Res:getY())

    local col = self:col()
    if Current.editing then
        local dr = 1
        if Input.ctrl.down then
            dr = 4
        end
        if Input.wheel.up then
            self.r = self.r+dr
        end
        if Input.wheel.down then
            self.r = self.r-dr
        end
        for i, type in ipairs(TYPES) do
            if Input[type].pressed then
                self.type = type
            end
        end
        if Input.mb[2].pressed then
            if #col > 0 then
                if col[1].tags.rotate then
                    Current:edit_remove(col[1].cx, col[1].cy)
                else
                    Current:edit_remove(col[1].x, col[1].y)
                end
            end
        end
        if Input.mb[1].pressed then
            Current:edit_add(x, y, self.r, self.type)
        end
    else
        for i, o in ipairs(col) do
            if o.tags.circle or o.tags.on and Current.on or o.tags.off and not Current.on then
                self:die()
            elseif o.tags.goal then
                self:goal()
            elseif o.tags.start then
                self:restart()
            end
        end
        if self.x < 0 or self.x > Res.w or self.y < 0 or self.y > Res.h then
            self:die()
        end
    end
end

function Mouse:goal()
    if not self.dead then
        Current:next()
        Camera:set_shake(2)
        for _ = 1, 5 do
            Current:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(10, 16))
        end
        Current:reset_timer()
        PlaySound("goal")
    end
end

function Mouse:die()
    if not self.dead then
        for _ = 1, 5 do
            Current:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(4, 10))
        end
        self.dead = true
        Camera:set_shake(1.2)
        Music:pause()
        PlaySound("die")
    end
end

function Mouse:restart()
    if self.dead then
        for _ = 1, 3 do
            Current:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(4, 10))
        end
        self.dead = false
        Camera:set_shake(1.2)
        Current:reset_timer()
        Music:play()
        PlaySound("restart")
    end
end

function Mouse:col()
    local found = {}
    for _, other in ipairs(Current.objects) do
        if other.tags.mouse_col then
            if self ~= other and Dist(self, other, other.r+1.4) then
                table.insert(found, other)
            end
        end
    end
    return found
end


function Mouse:draw()
    love.graphics.setColor(COLOR.LIGHT)
    love.graphics.circle("fill", self.x, self.y, 2)
    if Current.editing then
        love.graphics.setColor(Alpha(COLOR.LIGHT, 0.4))
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", self.x, self.y, self.r)
        love.graphics.print(self.type, self.x, self.y)
    end
    ResetColor()
end

return Mouse