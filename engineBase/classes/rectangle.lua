local rectangle = {}

local enum = require("engineBase.enum")

---@param renderableObj renderable
---@param renderData {}
---@param windowData windowData
rectangle.renderFunction = function(renderableObj, renderData, windowData)
    local pos = renderableObj.guiBase:getGlobalPixelPos(windowData)
    local size = renderableObj.guiBase.size:flushToOffset(windowData, false)

    love.graphics.setColor(renderableObj.colorObject:unpack())
    love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y)
end

rectangle.__index = rectangle

---@param renderableObj renderable
---@return rectangle
function rectangle.new(renderableObj)
    local self = setmetatable({}, rectangle)

    self.__type = enum.classType.rectangle

    self.renderable = renderableObj

    ---@diagnostic disable-next-line: inject-field
    self.renderable.renderFunction = rectangle.renderFunction
    self.renderable.renderData = {} -- no additional info needed

    return self
end

---@class rectangle
---@field __type "rectangle"
---@field renderable renderable
return rectangle