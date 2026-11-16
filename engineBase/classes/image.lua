local rectangle = {}

local enum = require("engineBase.enum")

---@param renderableObj renderable
---@param renderData {image: loveImageObject}
---@param windowData windowData
rectangle.renderFunction = function(renderableObj, renderData, windowData)
    local pos = renderableObj.guiBase:getGlobalPixelPos(windowData)
    local size = renderableObj.guiBase.size:flushToOffset(windowData, false)

    love.graphics.setColor(renderableObj.colorObject:unpack())
    love.graphics.draw(renderData.image, pos.x, pos.y, 0, size.x/renderData.image:getWidth(), size.y/renderData.image:getHeight())
end

rectangle.__index = rectangle

---@param imageObj loveImageObject
---@param renderableObj renderable
---@return image
function rectangle.new(imageObj, renderableObj)
    local self = setmetatable({}, rectangle)

    self.__type = enum.classType.image

    self.imageObj = imageObj
    self.renderable = renderableObj

    ---@diagnostic disable-next-line: inject-field
    self.renderable.renderFunction = rectangle.renderFunction
    self.renderable.renderData = {
        image = imageObj
    }

    return self
end

---@class image
---@field __type "image"
---@field imageObj loveImageObject
---@field renderable renderable
return rectangle