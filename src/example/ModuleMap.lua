local class = require "middleclass"
local ModuleLogin = require "src.example.login.ModuleLogin"
local ModuleMain = require "src.example.main.ModuleMain"

local ModuleMap = class('ModuleMap')
function ModuleMap:initialize()
    self.login = ModuleLogin:new();
    self.main = ModuleMain:new();
end

return ModuleMap
