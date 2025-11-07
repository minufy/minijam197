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

function Game:init()
    self.objects = {}
    self.mouse = Mouse:new()
    self.mouse:init()
    self.editing = false

    self.level_index = 1
    self:load_level()
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

function Game:draw()
    love.graphics.setColor(rgba(131, 28, 54, 1))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    
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