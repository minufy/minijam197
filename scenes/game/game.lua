local Game = {}

local Edit = require("scenes.game.edit")
Edit.attach(Game)

local Mouse = require("objects.mouse.mouse")
OBJECT_TYPES = {
    "circle",
    "goal",
    "start",
    "on",
    "off",
    "rotate_cw",
    "rotate_ccw",
}
local object_table = {}
for i, type in ipairs(OBJECT_TYPES) do
    object_table[type] = require("objects."..type)
end

local end_index = 20
local timer = 2*60
local on_timer = 0.5*60

function Game:add(object, ...)
    local o = object:new()
    o:init(...)
    table.insert(self.objects, o)
    return o
end

function Game:init()
    self.objects = {}
    self.timer = timer
    self.on_timer = on_timer
    self.on = true

    self.mouse = Mouse:new()
    self.mouse:init()
    self.editing = false
    
    self.level_index = 16
    self:load_level()
    Music:play()
end

function Game:update(dt)
    Edit.update(self, dt)
    if not self.editing then
        if self.level_index ~= end_index then
            if not self.mouse.dead then
                self.timer = self.timer-dt
                self.on_timer = self.on_timer-dt
            end
            if self.timer <= 0 then
                self.mouse:die()
            end
            if self.on_timer <= 0 then
                self.on_timer = on_timer
                self.on = not self.on
            end
        end
    end

    for i = #self.objects, 1, -1 do
        local object = self.objects[i]
        if object.update then
            object:update(dt)
        end
        if object.remove then
            table.remove(self.objects, i)
        end
    end
    self.mouse:update(dt)
end

function Game:draw_lines()
    love.graphics.setColor(1, 1, 1, 0.02)
    local mx = love.timer.getTime()*15%TILE_SIZE*2
    for x = -1, Res.w/TILE_SIZE do
        love.graphics.setLineWidth(TILE_SIZE)
        local nx = x*TILE_SIZE*2-Res.w/2
        love.graphics.line(nx+Res.h-mx, -TILE_SIZE, nx-TILE_SIZE-mx, Res.h+TILE_SIZE)
    end
    ResetColor()
end

function Game:draw()
    love.graphics.setColor(COLOR.BG)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    self:draw_lines()
    
    Camera:start()
    for i, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end
    self.mouse:draw()

    love.graphics.setColor(COLOR.LIGHT)
    love.graphics.rectangle("fill", 0, 0, self.timer/timer*Res.w, 3)
    love.graphics.print(tostring(self.level_index), 10, 10)
    if self.level_index == end_index then
        love.graphics.print("GG! you win", Res.w/2-Font:getWidth("GG! you win")/2 , 55)
        love.graphics.print("made by minufy", Res.w/2-Font:getWidth("made by minufy")/2 , 70)
    end
    ResetColor()
    
    Camera:stop()
end

function Game:reset_timer()
    self.timer = timer
    self.on_timer = on_timer
    self.on = true
end

function Game:next()
    self.level_index = self.level_index+1
    self:load_level()
end

function Game:load_level()
    self.level = require("assets.levels."..self.level_index)
    self:reload()
end
 
function Game:reload()
    self.objects = {}
    for _, o in pairs(self.level) do
        self:add(object_table[o.type], o.x, o.y, o.r)
    end
end

return Game