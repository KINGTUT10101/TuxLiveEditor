local ini = require ("libs.ini")

local defaultSettings = {
    showTooltips = true,
    scale = 1,
}

local settings = ini.load ("settings.ini") or defaultSettings

return settings