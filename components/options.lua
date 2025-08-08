local settings = require ("data.settings")
local colors = require ("data.colors")
local tux = require ("libs.tux")
local settingsMan = require ("helpers.settingsMan")

local settingsItems = {
    {
        key = "showTooltips",
        type = "boolean",
    },
    {
        key = "scale",
        type = "float",
        range = {
            min = 0.25,
            max = 5,
        }
    },
    {
        key = "toolbarHeight",
        type = "integer",
        range = {
            min = 5,
            max = 200,
        },
    },
    {
        key = "bgColor",
        type = "color",
        subtype = "r",
    },
    {
        key = "bgColor",
        type = "color",
        subtype = "g",
    },
    {
        key = "bgColor",
        type = "color",
        subtype = "b",
    },
    {
        key = "defCompDims",
        type = "dim",
        subtype = "x"
    },
    {
        key = "defCompDims",
        type = "dim",
        subtype = "y"
    },
    {
        key = "defCompDims",
        type = "dim",
        subtype = "w"
    },
    {
        key = "defCompDims",
        type = "dim",
        subtype = "h"
    },
}
local lineHeight = 25

local colorMap = {
    r = 1,
    g = 2,
    b = 3,
}

local function handleSettingItem (settingItem)
    tux.layout.pushNestedGrid ({
        padding = {x = 10},
        maxLineSize = lineHeight,
        maxLineLength = "100%",
    }, {}, "100%", "100%")
            
    if settingItem.type == "boolean" then
        local data = {
            checked = settings[settingItem.key],
        }

        tux.show.label ({
            colors = colors.none,
            text = settingItem.key .. " - " .. tostring (settings[settingItem.key]),
            align = "left",
            fsize = 10,
        }, tux.layout.nextItem ({}, "75%", "100%"))

        tux.show.toggle ({
            data = data,
        }, tux.layout.nextItem ({}, "25%", "100%"))

        settings[settingItem.key] = data.checked
    elseif settingItem.type == "color" then
        local data = {
            checked = (settings[settingItem.key][colorMap[settingItem.subtype]] > 0) and true or false,
        }

        tux.show.label ({
            colors = colors.none,
            text = settingItem.key .. "(" .. settingItem.subtype .. ")" .. " - " .. settings[settingItem.key][colorMap[settingItem.subtype]],
            align = "left",
            fsize = 10,
        }, tux.layout.nextItem ({}, "75%", "100%"))

        tux.show.checkbox ({
            data = data,
        }, tux.layout.nextItem ({}, "25%", "100%"))

        settings[settingItem.key][colorMap[settingItem.subtype]] = (data.checked == true) and 1 or 0

    elseif settingItem.type == "dim" then
        tux.show.label ({
            colors = colors.none,
            text = settingItem.key .. " - " .. settings[settingItem.key][settingItem.subtype],
            align = "left",
            fsize = 10,
        }, tux.layout.nextItem ({}, "50%", "100%"))

        if tux.show.button ({
            text = "-",
        }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
            local amount = (love.keyboard.isDown ("lshift") or love.keyboard.isDown ("rshift")) and 100 or 10
            settings[settingItem.key][settingItem.subtype] = settings[settingItem.key][settingItem.subtype] - amount
        end

        if tux.show.button ({
            text = "+",
        }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
            local amount = (love.keyboard.isDown ("lshift") or love.keyboard.isDown ("rshift")) and 100 or 10
            settings[settingItem.key][settingItem.subtype] = settings[settingItem.key][settingItem.subtype] + amount
        end

    elseif settingItem.type == "integer" or settingItem.type == "float" then
        local data = {
            value = tux.utils.mapToScale (settings[settingItem.key], settingItem.range.min, settingItem.range.max, 0, 1),
        }

        tux.show.label ({
            colors = colors.none,
            text = settingItem.key .. " - " ..
                (settingItem.type == "float"
                    and string.format("%.2f", settings[settingItem.key])
                    or (settingItem.type == "integer"
                        and string.format("%d", settings[settingItem.key])
                        or tostring(settings[settingItem.key]))),
            align = "left",
            fsize = 10,
        }, tux.layout.nextItem ({}, "50%", "100%"))

        tux.show.slider ({
            data = data,
        }, tux.layout.nextItem ({}, "50%", "100%"))

        if settingItem.type == "integer" then
            settings[settingItem.key] = math.floor (tux.utils.mapToScale (data.value, 0, 1, settingItem.range.min, settingItem.range.max) + 0.5)
        else
            settings[settingItem.key] = tux.utils.mapToScale (data.value, 0, 1, settingItem.range.min, settingItem.range.max)
        end
    end

    tux.layout.popGrid ()
end

local function options (opt, x, y, w, h)
    local page = opt.page
    local closed = false

    tux.layout.pushOrigin ({
        -- oalign = opt.oalign,
        -- voalign = opt.voalign,
        -- scale = opt.scale,
    }, x, y, w, h)

        local gridWidth = w * 0.90
        local gridHeight = h * 0.95

        tux.layout.pushGrid ({
            maxLineLength = gridWidth,
            maxLineSize = lineHeight,
            maxOverallSize = gridHeight,
            margins = {y = 3}
        }, (w - gridWidth) / 2, (h - gridHeight) / 2)
            tux.show.label ({
                text = "Options",
                fsize = 16,
                colors = colors.none,
            }, tux.layout.nextItem({}, "100%", "100%"))
            tux.layout.nextLine ()

            local maxItemSpace = tux.layout.remainingOverallSize ()
            local itemsPerPage = math.floor (maxItemSpace / lineHeight) - 2
            local startIndex = itemsPerPage * (page - 1) + 1
            local maxPage = math.ceil(#settingsItems / itemsPerPage)

            -- Menu controls
            tux.layout.pushNestedGrid ({
                padding = {x = 10},
                maxLineSize = lineHeight,
            }, {}, "100%", "100%")

                if tux.show.button ({
                    text = "Prev"
                }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
                    page = math.max (1, page - 1)
                end

                tux.show.label ({
                    text = page .. " / " .. maxPage,
                }, tux.layout.nextItem ({}, "50%", "100%"))

                if tux.show.button ({
                    text = "Next"
                }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
                    page = math.min (maxPage, page + 1)
                end

            tux.layout.popGrid ()

            tux.layout.nextLine ()
            if tux.show.button ({
                text = "Save",
            }, tux.layout.nextItem({}, "100%", "100%")) == "end" then
                closed = true
                settingsMan:save ()
            end

            for i = startIndex, startIndex + itemsPerPage do
                tux.layout.nextLine ()

                local settingItem = settingsItems[i]

                if not settingItem then
                    break
                end

                handleSettingItem (settingItem)
            end

        tux.layout.popGrid ()

        tux.show.label ({
            colors = colors.label
        }, 0, 0, w, h)
    tux.layout.popOrigin ()

    return closed, page
end

return options