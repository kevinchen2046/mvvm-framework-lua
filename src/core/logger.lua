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

local Color = {
    None = "",
    Red = "\27[31m",
    Green = "\27[32m",
    Yellow = "\27[33m",
    Blue = "\27[34m",
    Purple = "\27[1;35m"
}
local ColorSuffix = "\27[0m"

local Tag = {
    LOG = "[LOG]",
    INFO = "[INFO]",
    WARN = "[WARN]",
    ERROR = "[ERROR]",
    DEBUG = "[DEBUG]",
    OTHER = "[-]"
}
local ColorPrefix = {
    [Tag.LOG] = Color.None,
    [Tag.INFO] = Color.Green,
    [Tag.WARN] = Color.Yellow,
    [Tag.ERROR] = Color.Red,
    [Tag.DEBUG] = Color.Blue,
    [Tag.OTHER] = Color.Purple,
}
local ColorSuffix = {
    [Tag.LOG] = "",
    [Tag.INFO] = ColorSuffix,
    [Tag.WARN] = ColorSuffix,
    [Tag.ERROR] = ColorSuffix,
    [Tag.DEBUG] = ColorSuffix,
    [Tag.OTHER] = ColorSuffix,
}
Logger = {

    line = function(...)
        local args = { ... };
        local content = "";
        for k, v in pairs(args) do
            content = content .. tostring(v);
        end
        local total = 20;
        local len = total - string.len(content) / 2;
        local result = "";
        local i = 0;
        while (i < len) do
            result = result .. "-"
            i = i + 1;
        end
        result = result .. content;
        i = 0;
        while (i < len) do
            result = result .. "-"
            i = i + 1;
        end
        Logger.__out(Tag.OTHER, result);
    end,

    log = function(...)
        Logger.__out(Tag.LOG, ...);
    end,

    info = function(...)
        Logger.__out(Tag.INFO, ...);
    end,

    warn = function(...)
        Logger.__out(Tag.WARN, ...);
    end,

    debug = function(...)
        Logger.__out(Tag.DEBUG, ...);
    end,

    error = function(...)
        Logger.__out(Tag.ERROR, ...);
    end,

    __out = function(tag, ...)
        local result = ""
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...); -->读取参数
            if (type(arg) == 'table') then
                local table = "\n { \n";
                for k, v in pairs(arg) do
                    table = table .. '      ' .. k .. ":" .. tostring(v) .. ',\n'
                end
                table = table .. '  }'
                result = result .. table;
            else
                result = result .. ' ' .. tostring(arg);
            end
        end
        print(ColorPrefix[tag] .. tag .. result .. ColorSuffix[tag]);
    end
};
return Logger;
