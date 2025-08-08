local settings = require ("data.settings")
local json = require ("libs.json.json")
local tux = require ("libs.tux")

local settingsFilepath = "settings.json"

local settingsMan = {}

function settingsMan:save ()
    tux.utils.setScreenScale (settings.scale)
    tux.utils.setScreenSize (settings.defWindowDims.w, settings.defWindowDims.h)

    settings.defWindowDims.w = love.graphics.getWidth ()
    settings.defWindowDims.h = love.graphics.getHeight ()

    love.filesystem.write (settingsFilepath, json.encode (settings))
end

return settingsMan