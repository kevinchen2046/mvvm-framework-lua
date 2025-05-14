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
local Logger = require('src.core.logger');
local Array = require('src.core.array');
local EventEmiter = require('src.core.event');
local ClassUtil = require('src.utils.classutil');
local StringUtil = require('src.utils.stringutil');
local Object = require 'src.core.object'
local DECORATOR = require 'src.core.decorator'

local ReactiveObservable = class('ReactiveObservable')
local ReactiveProperty = class('ReactiveProperty')
local DataBase = class('DataBase', Object)
local ModuleBase = class('ModuleBase')
local CompBase = class('CompBase', EventEmiter)
local ViewBase = class('ViewBase', CompBase)
local Mvvm = class("Mvvm")

------------ReactiveObservable
function ReactiveObservable:initialize(reactproperty, callback)
    self.reactproperty = reactproperty;
    self.callback = callback;
end

function ReactiveObservable:notify(value)
    self.callback(value);
end

function ReactiveObservable:dispose(value)
    self.reactproperty:remove(self);
    self.reactproperty = nil;
    self.callback = nil;
end

------------ReactiveProperty

function ReactiveProperty:initialize(property, defaultValue)
    self.property = property;
    self._value = defaultValue
    self.observables = Array:new();
end

function ReactiveProperty:setValue(value)
    if self._value ~= value then
        self._value = value
        self:onNext(self._value);
    end
end

function ReactiveProperty:getValue(value)
    return self._value;
end

function ReactiveProperty:onNext(value)
    for i = 1, self.observables.length do
        self.observables:get(i):notify(value);
    end
end

function ReactiveProperty:subscribe(method, skip)
    skip = skip or false
    local obs = ReactiveObservable:new(self, method);
    self.observables:push(obs);
    if (skip == true) then
        obs.notify(self._value);
    end
    return obs;
end

function ReactiveProperty:remove(obs)
    self.observables:remove(obs);
end

function ReactiveProperty:clear()
    while self.observables.length > 0 do
        self.observables[0].dispose();
    end
end

----- DataBase
---
function DataBase:initialize()
    Object.initialize(self);
    self._reactmap = {};
    self._emitter = EventEmiter:new();
    self:onCreate();
end

function DataBase:onCreate()
end

function DataBase:on(type, listener, priority)
    self._emitter:on(type, listener, priority)
end

-- 取消事件
function DataBase:off(type, listener)
    self._emitter:off(type, listener)
end

-- 发送事件
function DataBase:emit(type, ...)
    self._emitter:emit(type, ...)
end

function DataBase:subscribe(property, callback)
    if self[property] == nil then
        print('subscribe property not found:', property);
        return
    end
    local reactprop
    if self._reactmap[property] == nil then
        reactprop = ReactiveProperty:new(property, self[property])
        self._reactmap[property] = reactprop
        self:__defineProperty(property,
            function(value)
                reactprop:setValue(value)
            end,
            function()
                return reactprop:getValue()
            end
        )
    end
    reactprop = self._reactmap[property]
    return reactprop:subscribe(callback)
end

----- ModuleBase

function ModuleBase:initialize()
    if DECORATOR.modules[self.class.name] then
        self.data = DECORATOR.modules[self.class.name].dataclazz:new()
    end
end

function ModuleBase:__initsubscribe()
    Mvvm.subscribeData(self)
end

function ModuleBase:onCreate()
end

function ModuleBase:execute(cmd, ...)
    Mvvm.execCmdToModules(cmd, ...)
end

----- VMBase

local VMBase = class('VMBase', DataBase)
function VMBase:initialize()
    DataBase.initialize(self);
end

---- Mvvm
Mvvm.static.modules = Array:new()
Mvvm.static.modulemap = {}
-- 静态方法
function Mvvm.static.initialize(ModuleMap)
    local uuid = require "uuid"
    uuid.set_rng(function(n)
        local bytes = {}
        for i = 1, n do
            bytes[i] = string.char(math.random(0, 255))
        end
        return table.concat(bytes)
    end)

    local modulemap = ModuleMap:new()
    for key, value in pairs(modulemap) do
        if value:isInstanceOf(ModuleBase) then
            -- print("modulemap:", key, value)
            Mvvm.modules:push(value)
            Mvvm.modulemap[value.class.name] = value
        end
    end
    Mvvm.modules:forEach(function(module)
        module:onCreate()
    end)
    Mvvm.modules:forEach(function(module)
        module:__initsubscribe()
    end)
    return modulemap
end

function Mvvm.static.getModule(classname)
    return Mvvm.modulemap[classname]
end

function Mvvm.static.subscribeData(target)
    if DECORATOR.datasubscribes[target.class.name] then
        local array = DECORATOR.datasubscribes[target.class.name]
        array:forEach(function(info)
            if info.modulename then
                local module = Mvvm.getModule(info.modulename)
                if module then
                    local sourceprop = info.sourceprop
                    local targetprop = info.targetprop
                    local sourceData = module.data
                    sourceData:subscribe(sourceprop, function(value)
                        target[targetprop] = value
                    end)
                    return
                end
            end
            Logger.error('subscribe not found module:', info.modulename)
        end)
        return
    end
    Logger.warn('Not found [', target.class.name, "] subscribes !")
end

function Mvvm.static.execCmdToModules(cmd, ...)
    if DECORATOR.commands[cmd] then
        local info = DECORATOR.commands[cmd]
        if info then
            local module = Mvvm.getModule(info.clazz.name)
            if module then
                module[info.callback](module, ...)
                return
            end
        end
    end
    Logger.error('command not found:' .. cmd)
end

function Mvvm.static.execCmdToVMs(cmd, ...)

end

return {
    ReactiveObservable = ReactiveObservable,
    ReactiveProperty = ReactiveProperty,
    DataBase = DataBase,
    ModuleBase = ModuleBase,
    VMBase = VMBase,
    CompBase = CompBase,
    ViewBase = ViewBase,
    Mvvm = Mvvm
}
