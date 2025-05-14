local class = require "middleclass"
local Array = require "src.core.array"
-- 定义静态类
local DECORATOR = class("DECORATOR")

-- -- 静态属性（类属性）
DECORATOR.static.modules = {}
DECORATOR.static.commands = {}
DECORATOR.static.datasubscribes = {}
-- 静态方法
function DECORATOR.static.DATA_SUBSCRIBE(clazz, modulename, sourceprop, targetprop)
    if DECORATOR.datasubscribes[clazz.name]==nil then
        DECORATOR.datasubscribes[clazz.name]=Array:new();
    end
    local array=DECORATOR.datasubscribes[clazz.name];
    array:push({
        modulename = modulename,
        sourceprop = sourceprop,
        targetprop = targetprop
    });
end

function DECORATOR.static.BIND_CMD(clazz, cmd, callback)
    DECORATOR.commands[cmd] = {
        clazz = clazz,
        callback = callback
    }
end

function DECORATOR.static.MODULE(clazz, dataclazz)
    DECORATOR.modules[clazz.name] = {
        clazz = clazz,
        dataclazz = dataclazz
    }
end

--- vm
function DECORATOR.static.VM(clazz)
    print("This is a static method!")
end

---- ui
function DECORATOR.static.UI(clazz)
    print("This is a static method!")
end

function DECORATOR.static.BIND_VALUE(clazz)
    print("This is a static method!")
end

function DECORATOR.static.BIND_LIST(clazz)
    print("This is a static method!")
end

-- -- 实例方法
-- function DECORATOR:initialize()
--     self.instance_property = "I am an instance property"
-- end

return DECORATOR
