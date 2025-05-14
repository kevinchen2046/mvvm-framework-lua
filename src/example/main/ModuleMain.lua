local class = require "middleclass"
local DataBase = (require "src.core.mvvm").DataBase
local ModuleBase = (require "src.core.mvvm").ModuleBase
local DECORATOR = require "src.core.decorator"
local Cmds = require "src.example.Cmds"

------- 模块数据
local MainData = class('MainData',DataBase)
    function MainData:onCreate()

    end

------- 模块
local ModuleMain = class('ModuleMain',ModuleBase)
---- 装饰器
        -- 绑定模块和模块数据
        DECORATOR.MODULE(ModuleMain,MainData)
        -- 绑定命令
        DECORATOR.BIND_CMD(ModuleMain,Cmds.LoginCmd.Login,"onLogin")
        -- 订阅数据
        DECORATOR.DATA_SUBSCRIBE(ModuleMain,"ModuleLogin","username","username")
    -- 创建完成
    function ModuleMain:onCreate()

    end
    function ModuleMain:onLogin(value)
        Logger.log("ModuleMain onLogin:",self.username)
    end
return ModuleMain