local Mouse = Object:new()

local Particle = require("objects.particle")

local Edit = require("objects.mouse.edit")

local damp = 0.9
local col_radius = 1.3
local draw_radius = 2
local max_d = 50

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
    local diff_x = Res:getX()-self.x
    local diff_y = Res:getY()-self.y

    -- 이동 거리가 최대 이동거리보다 크면 캡
    if diff_x^2+diff_y^2 > max_d^2 then
        diff_x = diff_x/max_d^0.5
        diff_y = diff_y/max_d^0.5
    end

    self.x = self.x+(diff_x)*damp*dt
    self.y = self.y+(diff_y)*damp*dt
    
    if Game.editing then
        Edit.update(self, dt)
    elseif Game.paused then
        local col = self:col("mouse_col")
        for i, o in ipairs(col) do
            if o.tags.start then
                Game:pause()
            end
        end
    else
        local col = self:col("mouse_col")
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
end

-- 태그를 가지고 충돌한 오브젝트들의 테이블 반환
function Mouse:col(tag)
    local found = {}
    for _, other in ipairs(Game.objects) do
        if other.tags[tag] then
            if self ~= other and Dist(self, other, other.r+col_radius) then
                table.insert(found, other)
            end
        end
    end
    return found
end

function Mouse:draw()
    love.graphics.setColor(COLOR.LIGHT)
    love.graphics.circle("fill", self.x, self.y, draw_radius)
    if Game.editing then
        Edit.draw(self)
    end
    ResetColor()
end

function Mouse:goal()
    if not self.dead then
        Game:next()
        Camera:set_shake(1.2)
        for _ = 1, 5 do
            Game:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(10, 16))
        end
        Game:reset_timer()
        Sounds.goal:play()
    end
end

function Mouse:die()
    if not self.dead then
        for _ = 1, 5 do
            Game:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(4, 10))
        end
        self.dead = true
        Camera:set_shake(1.2)
        Music:pause()
        Sounds.die:play()
    end
end

function Mouse:pause()
    if not self.dead then
        self.dead = true
        Camera:set_shake(1.2)
        Music:pause()
        Sounds.die:play()
    end
end

function Mouse:restart()
    if self.dead then
        for _ = 1, 3 do
            Game:add(Particle, self.x, self.y, math.random(-20, 20), math.random(-20, 20), math.random(4, 10))
        end
        self.dead = false
        Camera:set_shake(1.2)
        Game:reset_timer()
        Music:play()
        Sounds.restart:play()
    end
end

return Mouse