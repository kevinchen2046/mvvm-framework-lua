-------------------------------------
-------------------------------------
--- author:陈南
--- email:kevin-chen@foxmail.com
--- wechat:kevin_nan
--- date:2020.7.24
--- Copyright (c) 2020-present, KevinChen2046 Technology.
--- All rights reserved.
-------------------------------------
-------------------------------------

local class = require 'middleclass'
local Array = require 'src.core.array'

local EventEmiter = class('EventEmiter')

-- 构造函数
function EventEmiter:initialize()
    self._map = {}
end

-- 监听事件
-- type 事件类型
-- listener 事件回调
-- priority 事件优先级
function EventEmiter:on(type, listener, priority)
    if (priority == nil) then
        priority = 0;
    end
    if (self._map[type] == nil) then
        self._map[type] = Array:new();
    end
    local list = self._map[type];
    if (list:indexOf(listener) <= 0) then
        list:push({
            method = listener,
            priority = priority
        });
    end
end

-- 取消事件
function EventEmiter:off(type, listener)
    local list = self._map[type];
    if (list and list.length) then
        local off = 0;
        for i = 1, list.length do
            local object = list:get(i + off)
            if (object.method == listener) then
                list:removeAt(i);
                off = off - 1;
            end
        end
    end
end

-- 发送事件
function EventEmiter:emit(type, ...)
    local list = self._map[type];
    if (list and list.length) then
        list:sort(function(a, b)
            return (a.priority > b.priority)
        end);
        for i = 1, list.length do
            local object = list:get(i)
            object.method(...);
        end
    end
end

return EventEmiter;
