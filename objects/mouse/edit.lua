local Edit = {}

function Edit.update(self, dt)
    local col = self:col()

    local delta_r = 1
    if Input.ctrl.down then
        delta_r = 4
    end
    if Input.wheel.up then
        self.r = self.r+delta_r
    end
    if Input.wheel.down then
        self.r = self.r-delta_r
    end
    for _, type in ipairs(TYPES) do
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
        local x = math.floor(Res:getX())
        local y = math.floor(Res:getY())

        Current:edit_add(x, y, self.r, self.type)
    end
end

function Edit.draw(self)
    love.graphics.setColor(Alpha(COLOR.LIGHT, 0.4))
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", self.x, self.y, self.r)
    love.graphics.print(self.type, self.x, self.y)
end

return Edit