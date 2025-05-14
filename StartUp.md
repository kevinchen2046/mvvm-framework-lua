### 如何安装lua包：
    `luarocks install {name} --tree=.rocks`

### 如何使包查找生效:
入口文件添加如下代码
```lua
package.path = "./.rocks/share/lua/5.4/?.lua;" ..  -- 主模块路径
               "./.rocks/share/lua/5.4/?/init.lua;" ..  -- 包路径
               package.path
```

### 为lua添加oop封装：
第三方`middleclass`库
- 特点
  - ⭐ 简洁、清晰、易读，使用量最多。
  - 支持继承、构造函数、isInstanceOf 检查。
  - 零依赖，非常适合游戏开发（如 LÖVE 框架）。

### array
数组结构

数组遵循lua的基本规则，索引从1开始,异常索引将返回0.
```lua
Array -- 数组
    + -- 转换成字符串
    + toString(splitchar)
    + -- 添加元素到末尾
    + push(...)
    + -- 删除第一个匹配内容的项
    + remove(item, startIndex)
    + removeAt(index)
    + -- 删除所有匹配内容的项
    + removeAll(item)
    + -- 查找并返回索引 0为未查找到
    + indexOf(item)
    + -- 从末尾开始查找并返回索引 0为未查找到
    + lastIndexOf(item)
    + -- 插入元素
    + insert(item, index)
    + -- 删除第一个元素 并返回该元素
    + shift()
    + -- 删除最后一个元素 并返回该元素
    + pop()
    + -- 浅表克隆
    + concat(array)
    + -- 删除从起始位置到结束位置的元素,暂未实现添加元素
    + splice(start, _end, ...)
    + -- 数组排序
    + sort(comparefunc)
    + -- 取数组值
    + get(index)
    + -- 设置数组值
    + set(index, v)
    + -- 遍历数组
    + forEach(func)
```
基本用法
```lua
    -- 实例化一个数组 的同时可以初始化数组内容
    local array=Class.new(Array,'hello','world');
    prinf(array:get(1));
    -- > hello

    -- 数组的用法
    local array1=Class.new(Array,'a','b');
    array1:push('c','d','e','f','a1','b1','c1','d1','e1','f1');
    local array2=array1:splice(1,6);
    Logger.log(array1:toString());
    Logger.log(array2:toString());
    -- [LOG] [1 : a1, 2 : b1, 3 : c1, 4 : d1, 5 : e1, 6 : f1] (Len:6)
    -- [LOG] [1 : a, 2 : b, 3 : c, 4 : d, 5 : e, 6 : f] (Len:6)
```
### logger
```lua
Logger -- Logger除了添加了类型标签外，可以打印出类结构、数组结构及Table结构
    + -- 打印分隔线
    + line(...)
    +
    + log(...)
    + info(...)
    + warn(...)
    + debug(...)
    + error(...)
```
### event
```lua
EventEmiter -- 事件
    + -- 监听事件 
    + -- type 事件类型
    + -- listener 事件回调
    + -- priority 事件优先级
    + on(type, listener, priority)
    + -- 取消事件 
    + off(type, listener)
    + -- 发送事件 
    + emit(type, ...)
```
基本用法
```lua
    -- 实例化一个数组 的同时可以初始化数组内容
    local emiter=Class.new(EventEmiter);
    emiter:on('init',function(data)
        Logger.log(data);
    end);

    emiter:emit('init',{a=1,b=2});
    -- > { a:1,b:2 }
```

### mvvm
#### getter/setter 实现
  ```lua
  -- 要使用getter/setter,需要继承Object
  local Item = class('Item', Object)
  function Item:initialize()
      Object.initialize(self)
      self._itemName = "default" -- 先定义一个私有属性
      -- 定义getter/setter 依次传入属性名、setter、getter
      self:__defineProperty('itemName', -- 定义属性
          function(value)
              self._itemName = value
          end,
          function()
              return self._itemName
          end)
  end

  local item = Item:new()
  item.itemName = 'something'
  ```
#### 装饰器实现
  - 装饰器所有方法都需要大写字母以作区分
  - 并建议写在类定义的下方,两个缩进
比如:
  ```lua
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
  return ModuleMain
  ```
#### 反应属性实现
  ```lua
  local reactprop=ReactiveProperty:new()
  -- 订阅
  local obs=reactprop.subscribe(
    function(value)
      Logger.log("reactprop:",value)
    end)
  --更改
  reactprop.setValue("hello")
  --销毁观察者
  obs.dispose()
  ```
#### 数据订阅实现
  ```lua
  local data=DataBase:new()
  -- 订阅
  local obs=data.subscribe("name",
    function(value)
      Logger.log("reactprop:",value)
    end)
  --更改
  data.name="kevin"
  --销毁观察者
  obs.dispose()
  ```
#### 命令实现
#### 其他功能
  - 后面有时间实现下

mvvm基本用法
```lua
---------------------登陆模块
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

---------------------主模块
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
```
测试代码:
```lua
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

-- [-] ---------------Array Test---------------
-- [LOG] array: [1 : a, 2 : b] (Len:2)
-- [LOG] array pushed: [1 : a, 2 : b, 3 : c, 4 : d, 5 : e, 6 : f] (Len:6)
-- [LOG] array splice return: [1 : b, 2 : c, 3 : d, 4 : e] (Len:4)
-- [-] ------------EventEmiter Test------------
-- [LOG] Got event: INIT
-- [-] ----------------MVVM Test----------------
-- [WARN] Not found [ ModuleLogin ] subscribes !
-- [LOG] ModuleLogin loaded: kevin.chen
-- [LOG] ModuleMain onLogin: kevin.chen
```