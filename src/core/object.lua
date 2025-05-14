local class = require "middleclass"

local Object = class("Object")

-- 私有属性存储
local private = setmetatable({}, { __mode = "k" }) -- 弱引用表，避免内存泄漏


function Object:initialize()
    self:__initGetterSetterIntercept()
end

function Object:__defineProperty(name, setter, getter)
    rawset(self, name, nil)  -- 直接通过 rawset 删除属性
    private[self] = private[self] or {}
    private[self][name] = { setter, getter }
end

function Object:__initGetterSetterIntercept()
    -- 设置元表拦截属性访问
    local mt = getmetatable(self)
    mt.__index = function(s, key)
        local inst = s
        if private[inst] and private[inst][key] then
            return private[s][key][2]() -- 自动 Getter
        end
        return mt[key]                  -- 回退到类方法
    end

    mt.__newindex = function(s, key, value)
        local inst = s
        if private[inst] and private[inst][key] then
            -- 自动 Setter（可添加验证逻辑）
            private[inst][key][1](value)
        else
            rawset(inst, key, value) -- 非私有属性直接设置
        end
    end
end

return Object
