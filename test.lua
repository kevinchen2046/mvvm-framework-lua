package.path = "./.rocks/share/lua/5.4/?.lua;" ..      -- 主模块路径
    "./.rocks/share/lua/5.4/?/init.lua;" ..            -- 包路径
    package.path

local class = require 'middleclass'

local Object = require 'src.core.object'

local Mvvm = require 'src.core.mvvm'.Mvvm

local ModuleMap = require "src.example.modulemap"


-- 初始化模块
Mvvm.initialize(ModuleMap);

-- 触发登陆操作
local login=Mvvm.getModule("ModuleLogin")
login:loaded()

