local color = {}

color.__index = color

---@param r number
---@param g number
---@param b number
---@param a number
---@return color
function color.new(r, g, b, a)
    local self = setmetatable({}, color)

    self.r = r
    self.g = g
    self.b = b
    self.a = a

    return self
end

---@param r number
---@param g number
---@param b number
---@param a number
---@return color
function color.rgba(r, g, b, a)
    local self = setmetatable({}, color)

    self.r = r/255
    self.g = g/255
    self.b = b/255
    self.a = a

    return self
end

---@param a number
function color.none(a)
    return color.new(1, 1, 1, a)
end

---@param self color
---@return number, number, number, number
function color:unpack()
    return self.r, self.g, self.b, self.a
end

---@class color
---@field __type "color"
---@field r number
---@field g number
---@field b number
---@field a number
---@field unpack fun(self: color):number, number, number, number
return color