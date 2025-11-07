WINDOW_W = 192*4
WINDOW_H = 128*4
CONSOLE = true

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W
    t.window.height = WINDOW_H
end