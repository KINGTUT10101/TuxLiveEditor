local tux = require ("tux")
local colors = require ("data.colors")

local toolbarBtnWidth = 75

local function toolbar (hideui, mx, my)
    tux.layout.pushGrid ({
        padding = {
            x = 5,
            y = 5,
        },
        maxLineSize = 25,
    }, 0, 0)

    tux.show.button ({
        text = "LOAD"
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    tux.show.button ({
        text = "SAVE AS"
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    tux.show.button ({
        text = "SAVE"
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    tux.show.button ({
        text = "RELOAD"
    }, tux.layout.nextItem ({}, toolbarBtnWidth, "100%"))

    tux.show.button ({
        text = "OPTIONS"
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

    tux.show.label ({
        text = "FPS: " .. love.timer.getFPS(),
        colors = colors.none,
    }, tux.layout.nextItem ({}, 75, "100%"))

    tux.show.label ({
        text = "Debug: " .. ((tux.utils.getDebugMode () == true) and "On" or "Off"),
        colors = colors.none,
    }, tux.layout.nextItem ({}, 75, "100%"))

    tux.show.label ({
        text = "Mouse: " .. mx .. ", " .. my,
        colors = colors.none,
    }, tux.layout.nextItem ({}, 150, "100%"))

    tux.layout.popGrid ()

    tux.layout.setDefaultAlign ("left", "top")
    
    -- Toolbar background
    tux.show.label ({
        colors = colors.label
    }, 0, 0, tux.layout.getOriginWidth (), 25)

    return hideui
end

return toolbar