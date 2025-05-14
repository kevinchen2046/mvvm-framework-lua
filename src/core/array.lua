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

local Array = class('Array')

-- 构造函数
function Array:initialize(...)
    self.length = 0;
    self.data = {};
    self:push(...);
end

-- 转换成字符串
function Array:toString(splitchar)
    if (splitchar == nil) then
        splitchar = ",";
    end
    local result = "[";
    for k, v in pairs(self.data) do
        result = result .. k .. " : " .. v .. splitchar .. " ";
    end
    if (string.find(result, ",") ~= nil) then
        result = string.sub(result, 1, string.len(result) - 2);
    end
    result = result .. "] (Len:" .. self.length .. ")";
    return result;
end

-- 添加元素到末尾
function Array:push(...)
    for i = 1, select('#', ...) do
        local arg = select(i, ...)
        self.length = self.length + 1;
        self.data[self.length] = arg;
    end
end

-- 删除第一个匹配内容的项
function Array:remove(item, startIndex)
    if (startIndex == nil) then
        startIndex = 1;
    end
    local findIndex = 0;
    for k = startIndex, self.length do
        local v = self.data[k];
        if (v == item) then
            findIndex = k;
        end
        if (findIndex > 0 and (k + 1 <= self.length)) then
            self.data[k] = self.data[k + 1];
        end
    end
    if (findIndex > 0) then
        self.data[self.length] = nil;
        self.length = self.length - 1;
    end
    return findIndex;
end

-- 删除所有匹配内容的项
function Array:removeAll(item)
    local index = 1;
    while (index ~= 0) do
        index = self:remove(item, index - 1);
    end
end

function Array:removeAt(index)
    local finded = false;
    for k, v in pairs(self.data) do
        if (k == index) then
            finded = true;
        end
        if (finded and (k + 1 <= self.length)) then
            self.data[k] = self.data[k + 1];
        end
    end
    if (finded) then
        self.data[self.length] = nil;
        self.length = self.length - 1;
    end
end

function Array:indexOf(item)
    local index = 0;
    for i = 1, self.length do
        if (self.data[i] == item) then
            index = i;
            break;
        end
    end
    return index;
end

function Array:lastIndexOf(item)
    local index = 0;
    for i = 1, self.length do
        if (self.data[i] == item) then
            index = i;
            break;
        end
    end
    return index;
end

-- 插入元素
function Array:insert(item, index)
    if (index == nil) then
        index = 1;
    end
    table.insert(self.data, index, item);
end

-- 删除第一个元素 并返回该元素
function Array:shift(self)
    local result = self.data[1];
    for k = 1, self.length do
        if (k + 1 <= self.length) then
            self.data[k] = self.data[k + 1]
        end
    end
    self.data[self.length] = nil;
    self.length = self.length - 1;
    return result;
end

-- 删除最后一个元素 并返回该元素
function Array:pop(self)
    local result = self.data[self.length];
    self.data[self.length] = nil;
    self.length = self.length - 1;
    return result;
end

-- 浅表克隆
function Array:concat(array)
    local newarray = Array:new();
    for i = 1, self.length do
        newarray.data[i] = self.data[i];
    end
    for i = self.length + 1, self.length + array.length do
        newarray.data[i] = array.data[i - self.length];
    end
    newarray.length = self.length + array.length;
    return newarray;
end

-- 删除从起始位置到结束位置的元素,暂未实现添加元素
function Array:splice(start, _end, ...)
    local result = Array:new();
    local count = (_end - start) + 1;
    if (count > 0) then
        for k = start, _end do
            result.data[k - start + 1] = self.data[k];
        end
        result.length = count;
        for k = start, self.length do
            if (k + count <= self.length) then
                self.data[k] = self.data[k + count];
            else
                self.data[k] = nil;
            end
        end
        self.length = self.length - count;
    end
    return result;
    -- for i = 1, select('#', ...) do
    --     local arg = select(i, ...)
    --     self.length = self.length + 1;
    --     self.data[self.length] = arg;
    -- end
end

-- 数组排序
function Array:sort(comparefunc)
    table.sort(self.data, comparefunc);
end

-- 取数组值
function Array:get(index)
    if (index > self.length) then
        return nil;
    end
    return self.data[index];
end

-- 设置数组值
function Array:set(index, v)
    if (index > self.length) then
        -- local newlength=index;
        -- for i=self.length+1,newlength do
        --     self.data[i]=nil;
        -- end
        return;
    end
    self.data[index] = v;
end

-- 遍历数组
function Array:forIn(func)
    for k, v in pairs(self.data) do
        func(k, v);
    end
end

-- 遍历数组
function Array:forEach(func)
    for k, v in pairs(self.data) do
        func(v);
    end
end

return Array;
