local vector2 = {}

local enums = require("engineBase.enum")
local utils = require("engineBase.utils")

vector2.__index = vector2

---@param x number
---@param y number?
---@return vector2
function vector2.new(x, y)
    local self = setmetatable({}, vector2)
    assert(type(x) == "number" and (type(y) == "number" or not y), "get you shi together")

    self.__type = enums.classType.vector2
    self.x = x

    if y then
        self.y = y
    else
        self.y = x
    end

    return self
end

---@param self vector2
function vector2:print()
    print(self.x, self.y)
end

---@param self vector2
---@return number, number
function vector2:unpack()
    return self.x, self.y
end

---@param self vector2
---@param bound1 vector2
---@param bound2 vector2
---@return boolean
function vector2:isBetween(bound1, bound2)
    return utils.isWithin(self.x, bound1.x, bound2.x) and utils.isWithin(self.y, bound1.y, bound2.y)
end

---@param self vector2
---@param otherVector2 vector2
---@param t number
---@return vector2
function vector2:larp(otherVector2, t)
    if otherVector2.__type ~= enums.classType.vector2 then error("jump off.", 10) end
    return vector2.new(
        utils.larp(self.x, otherVector2.x, t),
        utils.larp(self.y, otherVector2.y, t)
    )
end

---@operator add:vector2
---@param a vector2
---@param b vector2
---@return vector2
function vector2.__add(a, b)
    if type(b) == "number" then
        return vector2.new(a.x + b, a.y + b)
    elseif b.__type == enums.classType.vector2 then
        return vector2.new(a.x + b.x, a.y + b.y)
    end
    error("ts not real bro", 10)
end

---@operator sub(vector2):vector2
---@param a vector2
---@param b vector2
---@return vector2
function vector2.__sub(a, b)
    if type(b) == "number" then
        return vector2.new(a.x - b, a.y - b)
    elseif b.__type == enums.classType.vector2 then
        return vector2.new(a.x - b.x, a.y - b.y)
    end
    error("ts isn't not fake bro", 10)
end

---@operator mul:vector2
---@param a vector2
---@param b vector2
---@return vector2
function vector2.__mul(a, b)
    if type(b) == "number" then
        return vector2.new(a.x * b, a.y * b)
    elseif b.__type == enums.classType.vector2 then
        return vector2.new(a.x * b.x, a.y * b.y)
    end
    error("ts not real bro", 10)
end

---@operator div:vector2
---@param a vector2
---@param b vector2
---@return vector2
function vector2.__div(a, b)
    if type(b) == "number" then
        return vector2.new(a.x / b, a.y / b)
    elseif b.__type == enums.classType.vector2 then
        return vector2.new(a.x / b.x, a.y / b.y)
    end
    error("ts fake bro", 10)
end

---@operator unm:vector2
---@param a vector2
---@return vector2
function vector2.__unm(a)
    return vector2.new(-a.x, -a.y)
end

---@param self vector2
---@param otherVector2 vector2
---@return number
function vector2:dot(otherVector2)
    if otherVector2.__type ~= enums.classType.vector2 then error("Fuck you.",10) end
    return self.x * otherVector2.x + self.y * otherVector2.y
end

---@param self vector2
---@return vector2
function vector2:unit()
    local magnitude = math.sqrt(self.x^2 + self.y^2)
    local newX = self.x/magnitude
    local newY = self.y/magnitude
    return vector2.new(newX, newY)
end

---@return vector2
function vector2.zero()
    return vector2.new(0)
end

---@class vector2
---@field __type classType
---@field x number
---@field y number
---@field print vector2 function, params:
---@field unpack [number, number] function, params:
---@field larp vector2 function, params: vector2, number
---@field isBetween boolean function, params: vector2, vector2
---@field dot vector2 function, params:
---@field unit vector2 function, params:
return vector2