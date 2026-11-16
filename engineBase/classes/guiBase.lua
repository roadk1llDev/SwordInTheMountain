local guiBase = {}

local sc2d = require("engineBase.classes.sc2d")
local enum = require("engineBase.enum")

guiBase.__index = guiBase

---@param pos sc2d
---@param size sc2d
---@param anchorPoint vector2
---@return guiBase
function guiBase.new(pos, size, anchorPoint)
    local self = setmetatable({}, guiBase)

    self.__type = enum.classType.guiBase

    self.pos = pos
    self.size = size
    self.anchorPoint = anchorPoint

    return self
end

---@param self guiBase
---@param windowData windowData
---@return vector2
function guiBase:getGlobalPixelPos(windowData)
    local scaledPos = self:getLocalScalePos(windowData)
    local pixelPos = sc2d.convertLocalScaleToPixel(scaledPos, windowData, true)
    return pixelPos
end

---@param self guiBase
---@param windowData windowData
---@return vector2
function guiBase:getLocalScalePos(windowData)
    local currentSizeScale = self.size:flushToLocalScale(windowData)
    local anchorOffsetScale = -self.anchorPoint*currentSizeScale
    local finalDrawPos = anchorOffsetScale + self.pos:flushToLocalScale(windowData)
    return finalDrawPos
end

---@class guiBase
---@field __type "guiBase"
---@field pos sc2d
---@field size sc2d
---@field anchorPoint vector2
---@field getGlobalPixelPos fun(self: guiBase, windowData: windowData): vector2
---@field getLocalScalePos fun(self: guiBase, windowData: windowData): vector2
return guiBase