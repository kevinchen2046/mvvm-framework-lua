#!/usr/local/bin/lua
-- main.lua
package.path = "./.rocks/share/lua/5.4/?.lua;" .. -- 主模块路径
    "./.rocks/share/lua/5.4/?/init.lua;" ..       -- 包路径
    package.path
local class = require 'middleclass'
local Logger = require('src.core.logger');
local Array = require('src.core.array');
local EventEmiter = require('src.core.event');
local class = require 'middleclass'
local Object = require 'src.core.object'
local Mvvm = require 'src.core.mvvm'.Mvvm
local ModuleMap = require "src.example.modulemap"

Logger.line('Array Test');

local array = Array:new('a', 'b');
Logger.log("array:", array:toString());
array:push('c', 'd', 'e', 'f');
Logger.log("array pushed:", array:toString());
local s = array:splice(2, 5);
Logger.log("array splice return:", s:toString());

Logger.line('EventEmiter Test');

local event = EventEmiter:new();
event:on('INIT', function()
    Logger.log('Got event: INIT')
end);
event:emit('INIT');


Logger.line('MVVM Test');
-- 初始化模块
Mvvm.initialize(ModuleMap);

-- 触发登陆操作
local login = Mvvm.getModule("ModuleLogin")
login:loaded()
