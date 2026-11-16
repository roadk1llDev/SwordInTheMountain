local interaction = {}

local enum = require("engineBase.enum")
local sc2d = require("engineBase.classes.sc2d")
local parentable = require("engineBase.classes.parentable")

local interactionHandler = require("engineBase.interactionHandler")

interaction.__index = interaction

local emptyFunc = function() end

---@param blocksHover boolean
---@param parentableObj parentable
---@param guiBase guiBase
---@param renderDebugVisuals boolean
---@return interaction
function interaction.new(blocksHover, parentableObj, guiBase, renderDebugVisuals)
    local self = setmetatable({}, interaction)

    self.__type = enum.classType.interaction

    self.blocksHover = blocksHover
    self.parentableObj = parentableObj
    self.guiBase = guiBase
    self.renderDebugVisuals = renderDebugVisuals

    self.parentableObj.parentObj = self

    self.hoverOnFunc = emptyFunc
    self.hoverOffFunc = emptyFunc
    self.clickFunc = emptyFunc
    self.isInside = false
    self.hasClickedOnSomething = false

    return self
end

---@param self interaction
---@param propertyTable table<string, any>
function interaction:tick(propertyTable)
    local localMouseScale = sc2d.convertPixelToLocalScale(propertyTable.mousePos, propertyTable.windowDataObj, true)

    local pos = self.guiBase:getLocalScalePos(propertyTable.windowDataObj)
    local size = self.guiBase.size:flushToLocalScale(propertyTable.windowDataObj)
    local isMouseWithInBounds = localMouseScale:isBetween(pos, pos + size)

    interactionHandler.addToStack(self, isMouseWithInBounds, propertyTable.click, propertyTable.windowDataObj)

    -- children.
    if #self.parentableObj.activeChildren == 0 then return end

    local newWindowData = parentable.getCurrentWindowData(self.guiBase, propertyTable.windowDataObj)
    propertyTable.windowDataObj = newWindowData
    self.parentableObj:processAllChildren(propertyTable)
end

---@class interaction
---@field __type "interaction"
---@field blocksHover boolean
---@field parentableObj parentable
---@field guiBase guiBase
---@field renderDebugVisuals boolean
---@field hoverOnFunc function
---@field hoverOffFunc function
---@field clickFunc function
---@field isInside boolean
---@field tick fun(self: interaction, propertyTable: table<string, any>)
return interaction