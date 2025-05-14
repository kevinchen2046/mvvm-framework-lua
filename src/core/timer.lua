local Logger = require("src.core.logger")
-- local restytimer = require("resty.timer")

local class = require "middleclass"

local timers = {}

function setTimeout(callback, delay)
    local start = os.clock()
    table.insert(timers, function()
        if os.clock() - start >= delay then
            callback()
            return true -- done
        end
        return false -- not done
    end)
end


-- 模拟主循环
while true do
    for i = #timers, 1, -1 do
        if timers[i]() then
            table.remove(timers, i)
        end
    end
    if #timers == 0 then break end
end

local Timer = class("Timer")

function Timer.static.setTimeout(callback, delay, ...)
    setTimeout(callback,delay)
end

function Timer.static.delay(delay, callback, ...)
    -- return restytimer.new({
    --     interval = delay,
    --     recurring = false,
    --     expire = callback
    -- }, ...)
end

return Timer