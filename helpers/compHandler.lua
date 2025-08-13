local log = require ("libs.log")
local settings = require ("data.settings")
local copyTable = require ("helpers.copyTable")
local tux = require ("libs.tux")

local compHandler = {
    errorOccurred = true,
    scriptFunc = nil,
    inputData = nil,
    scriptPath = nil,
    inputDataPath = nil,
    position = {
        x = 0,
        y = 0,
        w = 0,
        h = 0,
    },
    returnedValues = {},
}

local function unpackInputData (data)
    data = data or {}

    local actualData = {}

    for index, value in ipairs (data) do
        assert (type (value) == "table", "Input data at position " .. index .. " is not a table")

        local arg = nil
        if value.type == "const" then
            arg = value.arg

        elseif value.type == "x" then
            arg = compHandler.position.x

        elseif value.type == "y" then
            arg = compHandler.position.y

        elseif value.type == "w" then
            arg = compHandler.position.w

        elseif value.type == "h" then
            arg = compHandler.position.h
        end

        table.insert (actualData, arg)
    end

    return unpack (actualData)
end

function compHandler:loadScript (filepath)
    local success, data = pcall (dofile, filepath)
    self.errorOccurred = true

    if success == true then
        assert (type (data) == "function", "Provided script (type: " .. type (data) .. ") at " .. filepath .. " is not a function")

        if self.scriptPath ~= filepath then
            compHandler:setPosition (settings.defCompDims.x, settings.defCompDims.y, settings.defCompDims.w, settings.defCompDims.h)
        end
        
        self.scriptFunc = data
        self.scriptPath = filepath
        self.errorOccurred = false

        log.info ("Script " .. filepath .. " loaded successfully!")

        return true
    else
        log.error ("Failed to load script!")
        log.error (tostring (data))

        return false
    end
end

function compHandler:loadInputData (filepath)
    local success, data = pcall (dofile, filepath)
    self.errorOccurred = true

    if success == true then
        assert (type (data) == "table", "Provided input data (type: " .. type (data) .. ") at " .. filepath .. " is not a table")

        self.inputData = data
        self.inputDataPath = filepath
        self.errorOccurred = false

        log.info ("Input data " .. filepath .. " loaded successfully!")

        return true
    else
        log.error ("Failed to load input data!")
        log.error (tostring (data))

        return false
    end
end

function compHandler:reloadScript ()
    if self.scriptPath then
        return self:loadScript(self.scriptPath)
    else
        log.warn ("A script has not yet been loaded!")

        return false
    end
end

function compHandler:reloadInputData ()
    if self.inputDataPath then
        return self:loadInputData(self.inputDataPath)
    else
        log.warn ("Input data has not yet been loaded!")

        return false
    end
end

function compHandler:setPosition (x, y, w, h)
    self.position.x = x
    self.position.y = y
    self.position.w = w
    self.position.h = h
end

function compHandler:adjustPosition (x, y, w, h)
    self.position.x = self.position.x + x
    self.position.y = self.position.y + y
    self.position.w = self.position.w + w
    self.position.h = self.position.h + h
end

function compHandler:resetPosition (x, y)
    self.position.x = 0
    self.position.y = 0
end

function compHandler:update ()
    if self.scriptFunc ~= nil and self.errorOccurred == false then
        local originStack = copyTable (tux.layoutData.originStack)
        local gridStack = copyTable (tux.layoutData.gridStack)

        local results = {pcall (self.scriptFunc, unpackInputData(self.inputData))}
        local success = results[1]

        if success == true then
            self.returnedValues = {unpack (results, 2)}
        else
            log.error ("Error in update loop: " .. tostring (results[2]))
            self.errorOccurred = true
        end

        tux.layoutData.originStack = originStack
        tux.layoutData.gridStack = gridStack
    end
end

return compHandler