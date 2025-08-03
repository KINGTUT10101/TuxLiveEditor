local tux = require ("libs.tux")
local colors = require ("data.colors")

local lineHeight = 25

local function fileBrowser (opt, x, y, w, h)
    local selectedFile
    local page = opt.page

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
                text = opt.title,
                fsize = 16,
                colors = colors.none,
            }, tux.layout.nextItem({}, "100%", "100%"))
            tux.layout.nextLine ()

            local maxItemSpace = tux.layout.remainingOverallSize ()
            local itemsPerPage = math.floor (maxItemSpace / lineHeight)
            local startIndex = itemsPerPage * (page - 1) + 1

            -- Menu controls
            tux.layout.pushNestedGrid ({
                padding = {x = 10},
                maxLineSize = lineHeight,
            }, {}, "100%", "100%")

                if tux.show.button ({
                    text = "Prev"
                }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
                    
                end

                tux.show.label ({
                    text = page .. " / " .. math.ceil(#opt.files / itemsPerPage),
                }, tux.layout.nextItem ({}, "50%", "100%"))

                if tux.show.button ({
                    text = "Next"
                }, tux.layout.nextItem ({}, "25%", "100%")) == "end" then
                    
                end

            tux.layout.popGrid ()

            for i = startIndex, startIndex + itemsPerPage do
                tux.layout.nextLine ()

                local filename = opt.files[i]

                if not filename then
                    break
                end

                if tux.show.button ({
                    text = filename,
                }, tux.layout.nextItem ({}, "100%", "100%")) == "end" then
                    selectedFile = filename
                end
            end

        tux.layout.popGrid ()

        tux.show.label ({
            colors = colors.label
        }, 0, 0, w, h)
    tux.layout.popOrigin ()

    return selectedFile, page
end

return fileBrowser