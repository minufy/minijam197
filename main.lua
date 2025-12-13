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

    Music = love.audio.newSource("assets/sounds/music.ogg", "stream")
    Music:setVolume(0.3)
    Music:setLooping(true)
    Sounds = {}
    Sounds.die = love.audio.newSource("assets/sounds/die.ogg", "static")
    Sounds.die:setVolume(0.8)
    Sounds.goal = love.audio.newSource("assets/sounds/goal.ogg", "static")
    Sounds.goal:setVolume(0.5)
    Sounds.restart = love.audio.newSource("assets/sounds/restart.ogg", "static")
    Sounds.restart:setVolume(0.8)

    Res:init()
    SM:init("game.game")
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