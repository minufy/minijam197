require("stuff.object")
require("stuff.camera")
require("stuff.input")
require("stuff.res")
require("stuff.sm")
require("stuff.utils")

function love.load()
    -- load before setting filter
    -- FontHigh = love.graphics.newFont(60)
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)
    love.graphics.setFont(Font)
    TILE_SIZE = 32

    COLOR = {}
    COLOR.LIGHT = rgb(255, 243, 243)
    COLOR.HI = rgb(160, 124, 255)
    COLOR.BG = rgb(44, 44, 42)

    Res:init()
    SM:init("game")
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
end