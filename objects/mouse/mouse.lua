local Mouse = Object:new()

local Play = require("objects.mouse.play")
Play.attach(Mouse)
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
    
    if Current.editing then
        Edit.update(self, dt)
    else
        Play.update(self, dt)
    end
end

-- mouse_col 태그를 가지고 충돌한 오브젝트들의 테이블 반환
function Mouse:col()
    local found = {}
    for _, other in ipairs(Current.objects) do
        if other.tags.mouse_col then
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
    if Current.editing then
        Edit.draw(self)
    end
    ResetColor()
end

return Mouse