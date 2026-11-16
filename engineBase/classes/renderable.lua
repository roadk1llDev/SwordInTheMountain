local renderable = {}

local parentable = require("engineBase.classes.parentable")
local enum = require("engineBase.enum")

renderable.__index = renderable

local emptyFunc = function() end

---@param colorObject color
---@param parentableObj parentable
---@param guiBase guiBase
---@return renderable
function renderable.new(colorObject, parentableObj, guiBase)
    local self = setmetatable({}, renderable)

    self.__type = enum.classType.renderable

    self.colorObject = colorObject
    self.guiBase = guiBase
    self.parentableObj = parentableObj

    self.parentableObj.parentObj = self

    self.renderFunction = emptyFunc
    self.renderData = {}

    return self
end

---@param self renderable
---@param propertyTable table<string, any>
function renderable:render(propertyTable)
    if not propertyTable.click then
        ---@diagnostic disable-next-line: undefined-field
        self.renderFunction(self, self.renderData, propertyTable.windowDataObj)
    end

    -- children.
    if #self.parentableObj.activeChildren == 0 then return end
    local newWindowData = parentable.getCurrentWindowData(self.guiBase, propertyTable.windowDataObj)

    propertyTable.windowDataObj = newWindowData
    self.parentableObj:processAllChildren(propertyTable)
end

---@class renderable
---@field __type "renderable"
---@field colorObject color
---@field guiBase guiBase
---@field parentableObj parentable
---@field renderfunction function fun(renderableObj: renderable, renderData: table, windowData: windowData)
---@field renderData table
---@field render fun(self: renderable, propertyTable: table<string, any>)
return renderable