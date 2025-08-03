local tux = require ("libs.tux")
local colors = require ("data.colors")
local settings = require ("data.settings")
local lume = require ("libs.lume")

local fileBrowser = require ("components.fileBrowser")

local menuState = "none"
local toolbarBtnWidth = 75
local mouseAsPercent = false

local page = 1
local selectedFile

local files = nil

local function handleMenuState ()
    tux.layout.setDefaultAlign ("center", "center")

    if menuState == "openScript" then
        selectedFile, page = fileBrowser ({
            files = files,
            title = "Load script",
            page = page,
        }, 0, 0, 300, 450)

        if selectedFile ~= nil then
            menuState = "none"

            -- Load the file
            print ("Loading " .. selectedFile)
        end

    elseif menuState == "openData" then
        selectedFile, page = fileBrowser ({
            files = files,
            title = "Load input data",
            page = page,
        }, 0, 0, 300, 450)

        if selectedFile ~= nil then
            menuState = "none"

            -- Load the file
            print ("Loading " .. selectedFile)
        end

    elseif menuState == "options" then
        
    else
        page = 1
        selectedFile = nil
        files = nil
    end
end

local function toolbar (hideui, mx, my)
    handleMenuState ()

    tux.layout.setDefaultAlign ("left", "top")
    tux.layout.pushGrid ({
        padding = {
            x = 5,
            y = 5,
        },
        maxLineSize = 25,
    }, 0, 0)

    if tux.show.button ({
        text = "SCRIPT",
        tooltip = {
            text = (settings.showTooltips == true) and "Loads a script file" or ""
        }
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%")) == "end" then
        menuState = (menuState ~= "openScript") and "openScript" or "none"
        if menuState == "openScript" then
            files = lume.sort (love.filesystem.getDirectoryItems ("Scripts"))
        end
    end

    if tux.show.button ({
        text = "INPUT",
        tooltip = {
            text = (settings.showTooltips == true) and "Loads an input data file" or ""
        }
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%")) == "end" then
        menuState = (menuState ~= "openData") and "openData" or "none"
        if menuState == "openData" then
            files = lume.sort (love.filesystem.getDirectoryItems ("Inputs"))
        end
    end

    tux.show.button ({
        text = "RELOAD",
        tooltip = {
            text = (settings.showTooltips == true) and "Reloads the current script and input data" or ""
        }
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    if tux.show.button ({
        text = "FOLDER",
        tooltip = {
            text = (settings.showTooltips == true) and "Opens the folder containing the project files" or ""
        }
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%")) == "end" then
        love.system.openURL ("file://"..love.filesystem.getSaveDirectory())
    end

    tux.show.button ({
        text = "OPTIONS",
        tooltip = {
            text = (settings.showTooltips == true) and "Opens the options menu" or ""
        }
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    tux.layout.popGrid ()

    tux.layout.setDefaultAlign ("right", "top")
    tux.layout.pushGrid ({
        padding = {
            x = 5,
            y = 5,
        },
        maxLineSize = 25,
        dir = "left",
    }, 0, 0)

    -- print (tux.layout.nextItem ({}, 75, "100%"))
    -- print (tux.core.applyOrigin (nil, nil, nil, tux.layout.nextItem ({}, 75, "100%")))
    -- print ()

    tux.show.label ({
        text = "FPS: " .. love.timer.getFPS(),
        colors = colors.none,
    }, tux.layout.nextItem ({}, 75, "100%"))

    if tux.show.label ({
        text = "Debug: " .. ((tux.utils.getDebugMode () == true) and "On" or "Off"),
        colors = colors.none,
    }, tux.layout.nextItem ({}, 75, "100%")) == "end" then
        tux.utils.setDebugMode (not tux.utils.getDebugMode ())
    end

    if mouseAsPercent == true then
        mx = math.floor (mx / love.graphics.getWidth() * 100) .. "%"
        my = math.floor (my / love.graphics.getHeight() * 100) .. "%"
    end

    if tux.show.label ({
        text = "Mouse: " .. mx .. ", " .. my,
        colors = colors.none,
    }, tux.layout.nextItem ({}, 150, "100%")) == "end" then
        mouseAsPercent = not mouseAsPercent
    end

    tux.layout.popGrid ()

    

    tux.layout.setDefaultAlign ("left", "top")
    
    -- Toolbar background
    tux.show.label ({
        colors = colors.label
    }, 0, 0, tux.layout.getOriginWidth (), 25)

    return hideui
end

return toolbar