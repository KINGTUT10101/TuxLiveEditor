local threadFuncStr = [[
require ("love.system")
local filepath = ...

love.system.openURL (filepath)
]]

local thread = love.thread.newThread (threadFuncStr)

-- Asynchronously opens a URL
local function asyncOpenURL (filepath)
    thread:start (filepath)
end

return asyncOpenURL