local json = require ("libs.json.json")

local defaultSettings = {
    showTooltips = true,
    scale = 1,
    toolbarHeight = 25,
    bgColor = {0, 0, 0, 0},
    defCompDims = {
        x = 50,
        y = 50,
        w = 100,
        h = 100,
    },
    defWindowDims = {
        w = love.graphics.getWidth (),
        h = love.graphics.getHeight (),
    }
}

local settings = json.decode (love.filesystem.read ("settings.json") or "{}")

-- Set to defaults if settings is empty
for key, value in pairs (defaultSettings) do
    if settings[key] == nil then
        settings[key] = value
    end
end

return settings