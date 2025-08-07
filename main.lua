local tux = require ("libs.tux")
local log = require ("libs.log")
local settings = require ("data.settings")
local compHandler = require ("helpers.compHandler")

log.usecolor = false
log.info ("Starting Tux Live Editor...")

-- Sets up Tux
tux.utils.setScreenScale (settings.scale)

-- UI components
local toolbar = require ("components.toolbar")
local fileBrowser = require ("components.fileBrowser")

local hideui = false
local script = nil -- A function that creates a UI component every frame
local inputData = nil -- Input data for the UI component

love.filesystem.createDirectory ("Scripts")
love.filesystem.createDirectory ("Inputs")

log.info ("Tux Live Editor started successfully!")

function love.update (dt)
    tux.callbacks.update (dt)

    local mx, my = love.mouse.getPosition ()

    if hideui == false then
        hideui = toolbar (hideui, mx, my)
    end

    compHandler:update ()
end

function love.draw ()
    tux.callbacks.draw ()
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

    elseif key == "r" then
        if love.keyboard.isDown ("lshift") == true then
            compHandler:reloadScript ()
        elseif love.keyboard.isDown ("lctrl") == true then
            compHandler:reloadInputData ()
        end
    end
end

function love.resize (w, h)
    tux.utils.setScreenSize (w, h)
end

function love.filedropped (file)

end