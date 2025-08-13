local tux = require ("libs.tux")
local log = require ("libs.log")
local settings = require ("data.settings")
local compHandler = require ("helpers.compHandler")
local settingsMan = require ("helpers.settingsMan")

log.usecolor = false
log.info ("Starting Tux Live Editor...")

-- Set screen dimensions
love.window.setMode (settings.defWindowDims.w, settings.defWindowDims.h, {
    resizable = true,
})

-- Sets up Tux
tux.utils.setScreenScale (settings.scale)
tux.utils.setScreenSize (settings.defWindowDims.w, settings.defWindowDims.h)

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
    local success, result = xpcall (function () tux.callbacks.update (dt) end, debug.traceback)

    if success == false and compHandler.errorOccurred == false then
        log.error ("Error in Tux update callback: ", tostring (result))
        compHandler.errorOccurred = true

        tux.layout.clearStacks ()
    end

    local mx, my = love.mouse.getPosition ()

    if hideui == false then
        hideui = toolbar (hideui, mx, my)
    end

    -- Adjusts the x/y coords or the width/height of the component
    local shiftHeld = love.keyboard.isDown("lshift", "rshift")

    if shiftHeld then
        if love.keyboard.isDown("left", "a") then
            compHandler:adjustPosition(0, 0, -settings.camVelocity * dt, 0)
        end
        if love.keyboard.isDown("right", "d") then
            compHandler:adjustPosition(0, 0, settings.camVelocity * dt, 0)
        end
        if love.keyboard.isDown("up", "w") then
            compHandler:adjustPosition(0, 0, 0, -settings.camVelocity * dt)
        end
        if love.keyboard.isDown("down", "s") then
            compHandler:adjustPosition(0, 0, 0, settings.camVelocity * dt)
        end
    else
        if love.keyboard.isDown("left", "a") then
            compHandler:adjustPosition(-settings.camVelocity * dt, 0, 0, 0)
        end
        if love.keyboard.isDown("right", "d") then
            compHandler:adjustPosition(settings.camVelocity * dt, 0, 0, 0)
        end
        if love.keyboard.isDown("up", "w") then
            compHandler:adjustPosition(0, -settings.camVelocity * dt, 0, 0)
        end
        if love.keyboard.isDown("down", "s") then
            compHandler:adjustPosition(0, settings.camVelocity * dt, 0, 0)
        end
    end

    compHandler:update ()
end

function love.draw ()
    love.graphics.setBackgroundColor (settings.bgColor)
    local success, result = xpcall (tux.callbacks.draw, debug.traceback)

    if success == false and compHandler.errorOccurred == false then
        compHandler.errorOccurred = true
        log.error ("Error in Tux draw callback: ", tostring (result))
    end
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
        else
            compHandler:reloadScript ()
            compHandler:reloadInputData ()
        end

    elseif key == "q" then
        compHandler:resetPosition ()

    elseif key == "x" then
        compHandler.errorOccurred = true
        log.error ("An error was manually triggered by the user")
    end
end

function love.resize (w, h)
    tux.utils.setScreenSize (w, h)
end

function love.filedropped (file)

end

function love.quit ()
    settingsMan:save ()
end