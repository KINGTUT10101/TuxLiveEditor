local compHandler = {
    scriptFunc = nil,
    inputData = nil,
    scriptPath = nil,
    inputDataPath = nil,
    position  = {
        x = 0,
        y = 0,
        w = 0,
        h = 0,
    }
}

local function unpackInputData (data)
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
end

function compHandler:loadScript (filepath)
    local success, data = pcall (dofile (filepath))

    if success == true then
        assert (type (data) == "function", "Provided script is not a function")

        self.scriptFunc = data
        self.scriptPath = filepath
    else
        print ("Failed to load script!")
        print (data)
    end
end

function compHandler:loadInputData (filepath)
    local success, data = pcall (dofile (filepath))

    if success == true then
        assert (type (data) == "table", "Provided input data is not a table")

        self.inputData = data
        self.inputDataPath = filepath
    else
        print ("Failed to load input data!")
        print (data)
    end
end

function compHandler:reloadScript ()
    if self.scriptPath then
        self:loadScript(self.scriptPath)
    end
end

function compHandler:reloadInputData ()
    if self.inputDataPath then
        self:loadInputData(self.inputDataPath)
    end
end

function compHandler:adjustPosition (x, y, w, h)
    self.position.x = x
    self.position.y = y
    self.position.w = w
    self.position.h = h
end

function compHandler:update ()
    if self.scriptFunc then
        self.scriptFunc(unpackInputData(self.inputData))
    end
end

return compHandler