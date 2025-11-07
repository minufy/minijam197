local lume = require("modules.lume")

local Game = {}

local Mouse = require("objects.mouse")
local types = {
    circle = require("objects.circle"),
    goal = require("objects.goal"),
    start = require("objects.start"),
}

function Game:add(object, ...)
    local o = object:new()
    o:init(...)
    table.insert(self.objects, o)
    return o
end

local timer = 4*60

function Game:init()
    self.objects = {}
    self.mouse = Mouse:new()
    self.mouse:init()
    self.editing = false

    self.timer = timer

    self.level_index = 1
    self:load_level()
end

function Game:reset_timer()
    self.timer = timer
end

function Game:update(dt)
    if CONSOLE then
        if Input.toggle_editor.pressed then
            self.editing = not self.editing
        end
        if Input.ctrl.down then
            if Input.save.pressed then
                self:edit_save()
            end
        end
    end
    
    if not self.editing then
        if not self.mouse.dead then
            self.timer = self.timer-dt
        end
        if self.timer <= 0 then
            self.mouse:die()
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
    love.graphics.setColor(0.1, 0.1, 0.1, 0.1)
    local mx = love.timer.getTime()*15%TILE_SIZE*2
    for x = -1, Res.w/TILE_SIZE do
        love.graphics.setLineWidth(TILE_SIZE*2)
        local nx = x*TILE_SIZE*2-Res.w/2
        love.graphics.line(nx+Res.h-mx, -TILE_SIZE, nx-TILE_SIZE-mx, Res.h+TILE_SIZE)
    end
    ResetColor()
end

function Game:draw()
    love.graphics.setColor(rgba(131, 28, 54, 1))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    self:draw_lines()
    
    Camera:start()
    -- table.sort(self.objects, function (a, b)
    --     return a.z < b.z
    -- end)
    for i, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end
    self.mouse:draw()

    love.graphics.setColor(COLOR.LIGHT)
    love.graphics.rectangle("fill", 0, 0, self.timer/timer*Res.w, 3)
    ResetColor()

    Camera:stop()
end

function Game:edit_remove(x, y)
    self.level[x..","..y] = nil
    self:reload()
end

function Game:edit_add(x, y, r, type)
    self.level[x..","..y] = {
        x = x,
        y = y,
        r = r,
        type = type
    }
    self:reload()
end

function Game:edit_save()
    local data = "return "..lume.serialize(self.level)
    local path = "assets/levels/"..self.level_index..".lua"
    local file, err = io.open(path, "w")
    if file then
        file:write(data)
        file:close()
        print("saved to "..path)
    else
        print(err)
    end
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
    for i, o in pairs(self.level) do
        self:add(types[o.type], o.x, o.y, o.r)
    end
end

return Game