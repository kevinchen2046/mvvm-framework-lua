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
local class = require "middleclass"
-- 定义静态类
local StringUtil = class("StringUtil")

-- 静态方法
function StringUtil.static.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
function StringUtil.static.firstToLower(str)
    return (str:gsub("^%u", string.lower))
end

return StringUtil;
