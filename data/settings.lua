local ini = require ("libs.ini")

local defaultSettings = {
    showTooltips = true,
    scale = 1,
    toolbarHeight = 25,
    bgColor = {0, 0, 0, 0},
    defCompDims = {
        x = ""
    }
}

local settings = ini.load ("settings.ini") or defaultSettings

return settings