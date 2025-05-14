package.path = "./.rocks/share/lua/5.4/?.lua;" .. -- 主模块路径
    "./.rocks/share/lua/5.4/?/init.lua;" ..       -- 包路径
    package.path
local class = require "middleclass"

local Object = class("Object")

-- 私有属性存储
local private = setmetatable({}, { __mode = "k" }) -- 弱引用表，避免内存泄漏

function Object:initialize()
    self:__initGetterSetterIntercept()
end

function Object:__defineProperty(name, setter, getter)
    rawset(self, name, nil) -- 直接通过 rawset 删除属性
    private[self] = private[self] or {}
    private[self][name] = { setter, getter }
end

function Object:__initGetterSetterIntercept()
    -- 设置元表拦截属性访问
    local mt = getmetatable(self)
    mt.__index = function(s, key)
        print("get:", s, key)
        local inst = s
        if private[inst] and private[inst][key] then
            return private[inst][key][2]() -- 自动 Getter
        end
        return mt[key]                     -- 回退到类方法
    end

    mt.__newindex = function(s, key, value)
        print("set:", s, key, value)
        local inst = s
        if private[inst] and private[inst][key] then
            -- 自动 Setter（可添加验证逻辑）
            private[inst][key][1](value)
        else
            rawset(inst, key, value) -- 非私有属性直接设置
        end
    end
end

local DataBase = class('DataBase', Object)
function DataBase:initialize()
    Object.initialize(self)
    self._itemName = "default" -- 先定义一个属性值
end

function DataBase:create()
    self:__defineProperty('itemName', -- 定义属性
        function(value)
            self._itemName = value
        end,
        function()
            return self._itemName
        end)
end

local data = DataBase:new()
data.itemName = "abc"  -- 第一次设置，触发 __newindex
data:create()
data.itemName = "abc1" -- 后续设置，仍然触发 __newindex
data.itemName = "abc2" -- 再次设置，仍然触发 __newindex
