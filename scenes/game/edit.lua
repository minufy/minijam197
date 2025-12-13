local lume = require("modules.lume")

local Edit = {}

function Edit.update(self, dt)
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
    
    if self.editing then
        if Input.right.pressed then
            self.level_index = self.level_index+1
            self:load_level()
        end
        if Input.left.pressed then
            self.level_index = self.level_index-1
            self:load_level()
        end
    end
end

function Edit.edit_remove(self, x, y)
    self.level[x..","..y] = nil
    self:reload()
end

function Edit.edit_add(self, x, y, r, type)
    self.level[x..","..y] = {
        x = x,
        y = y,
        r = r,
        type = type
    }
    self:reload()
end

function Edit.edit_save(self)
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

function Edit.attach(Game)
    Game.edit_remove = Edit.edit_remove
    Game.edit_add = Edit.edit_add
    Game.edit_save = Edit.edit_save
end

return Edit