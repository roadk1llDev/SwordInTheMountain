local sc2d = {}

local enums = require("engineBase.enum")
local vector2 = require("engineBase.classes.vector2")

sc2d.__index = sc2d

---@param xScale number
---@param xOffset number
---@param yScale number
---@param yOffset number
---@return sc2d
function sc2d.new(xScale, xOffset, yScale, yOffset)
    local self = setmetatable({}, sc2d)

    self.__type = enums.classType.sc2d

    self.x = {
        scale = xScale,
        offset = xOffset
    }

    self.y = {
        scale = yScale,
        offset = yOffset
    }

    self.scale = {
        x = xScale,
        y = yScale
    }

    self.offset = {
        x = xOffset,
        y = yOffset
    }

    self.vectorScale = vector2.new(xScale, yScale)

    self.vectorOffset = vector2.new(xOffset, yOffset)

    return self
end

---@param xScale number
---@param yScale number
---@return sc2d
function sc2d.fromScale(xScale, yScale)
    local self = sc2d.new(xScale, 0, yScale, 0)

    return self
end

---@param xOffset number
---@param yOffset number
---@return sc2d
function sc2d.fromOffset(xOffset, yOffset)
    local self = sc2d.new(0, xOffset, 0, yOffset)

    return self
end

---@param self sc2d
---@param windowData windowData
---@return vector2
function sc2d:flushToLocalScale(windowData)
    return self.scale + sc2d.convertPixelToLocalScale(self.offset, windowData, false)
end

---@param self sc2d
---@param windowData windowData
---@param isGlobal boolean
---@return vector2
function sc2d:flushToOffset(windowData, isGlobal)
    return self.offset + sc2d.convertLocalScaleToPixel(self.scale, windowData, isGlobal)
end

---@param pixelPos vector2
---@param windowData windowData
---@param isGlobalPos boolean
---@return vector2
function sc2d.convertPixelToLocalScale(pixelPos, windowData, isGlobalPos)
    local imageStartPos = windowData.pos
    local centerSize = windowData.size

    local offsetStartPos = pixelPos - (isGlobalPos and imageStartPos or vector2.zero())
    return offsetStartPos / centerSize
end

---@param scalePos vector2
---@param windowData windowData
---@param isGlobalPos boolean
---@return vector2
function sc2d.convertLocalScaleToPixel(scalePos, windowData, isGlobalPos)
    local imageStartPos = windowData.pos
    local centerSize = windowData.size

    local scaledSize = scalePos * centerSize
    return scaledSize + (isGlobalPos and imageStartPos or vector2.zero())
end

---@class sc2d
---@field __type classType
---@field x {scale: number, offset: number}
---@field y {scale: number, offset: number}
---@field scale {x: number, y: number}
---@field offset {x: number, y: number}
---@field vectorScale vector2
---@field vectorOffset vector2
---@field flushToLocalScale vector2 function, params: windowData: windowData
---@field flushToOffset vector2 function, params: windowData: windowData, isGlobal: boolean
return sc2d