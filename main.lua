local tux = require ("tux")

-- UI components
local toolbar = require ("components.toolbar")

local hideui = false

function love.update (dt)
    tux.callbacks.update (dt)

    local mx, my = love.mouse.getPosition ()

    if hideui == false then
        hideui = toolbar (hideui, mx, my)
    end
end

function love.draw ()
    tux.callbacks.draw ()

    -- local mx, my = love.mouse.getPosition ()
    -- love.graphics.setColor (1, 1, 1, 1)
    -- love.graphics.print (mx .. ", " .. my, 700, 25)
end

function love.textinput (text)
    tux.callbacks.textinput (text)
end

function love.keypressed (key, scancode, isrepeat)
    tux.callbacks.keypressed (key, scancode, isrepeat)

    if key == "/" then
        hideui = not hideui

    elseif key == "m" then
        tux.utils.setDebugMode (not tux.utils.getDebugMode ())
    end
end

function love.resize (w, h)
    tux.utils.setScreenSize (w, h)
end

function love.filedropped (file)

end