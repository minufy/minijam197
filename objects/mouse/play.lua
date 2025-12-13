local Play = {}

local Particle = require("objects.particle")

function Play.update(self, dt)
    local col = self:col()
    for i, o in ipairs(col) do
        if o.tags.circle or o.tags.on_off then
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

function Play.goal(self)
    if not self.dead then
        Current:next()
        Camera:set_shake(1.5)
        for _ = 1, 5 do
            Current:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(10, 16))
        end
        Current:reset_timer()
        PlaySound("goal")
    end
end

function Play.die(self)
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

function Play.restart(self)
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

function Play.attach(Mouse)
    Mouse.goal = Play.goal
    Mouse.die = Play.die
    Mouse.restart = Play.restart
end

return Play