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

local Logger = require("src.core.logger");

local class = require "middleclass"
-- 定义静态类
local ClassUtil = class("StringClassUtilUtil")

-- 静态方法
function ClassUtil.static.getClassName(object)
    return object.class.name
end
function ClassUtil.static.printClassChain(instance)
    print(instance)
        local chain = {}
        local current_class = instance.class
        while current_class do
            table.insert(chain, current_class.name)
            current_class = current_class.super
        end
        print("Inheritance chain: " .. table.concat(chain, " -> "))
end

return ClassUtil;
