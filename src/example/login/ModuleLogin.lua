local class = require "middleclass"
local DataBase = (require "src.core.mvvm").DataBase
local ModuleBase = (require "src.core.mvvm").ModuleBase
local DECORATOR = require "src.core.decorator"
local Timer = require "src.core.timer"
local Cmds = require "src.example.Cmds"

------- 模块数据
local LoginData = class('LoginData',DataBase)
    function LoginData:onCreate()
        self.username=""
    end

------- 模块
local ModuleLogin = class('ModuleLogin',ModuleBase)
        --- 装饰器
        DECORATOR.MODULE(ModuleLogin,LoginData)

    function ModuleLogin:onCreate()

    end

    function ModuleLogin:loaded()
        self.data.username="kevin.chen"
        Logger.log("ModuleLogin loaded:",self.data.username)
        self:execute(Cmds.LoginCmd.Login,self.data.username);
    end

return ModuleLogin