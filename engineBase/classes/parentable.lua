local parentable = {}

local enum = require("engineBase.enum")
local utils = require("engineBase.utils")
local windowData = require("engineBase.structs.windowData")
local sc2d = require("engineBase.classes.sc2d")

parentable.__index = parentable

---@param active boolean
---@param zIndex integer
---@return parentable
function parentable.new(active, zIndex)
    local self = setmetatable({}, parentable)

    self.__type = enum.classType.parentable

    self.active = active
    self.zIndex = zIndex

    self.parentObj = nil
    self.parentParentable = nil
    self.activeChildren = {}
    self.children = {}

    return self
end

-- misc

---@param guiBase guiBase
---@param windowDataObj windowData
---@return windowData
function parentable.getCurrentWindowData(guiBase, windowDataObj)
    return windowData.new(
        sc2d.convertLocalScaleToPixel(guiBase:getLocalScalePos(windowDataObj), windowDataObj, true),
        guiBase.size:flushToOffset(windowDataObj, false)
    )
end

---@param self parentable
---@param propertyTable table<string, any>
function parentable:processAllChildren(propertyTable)
    for _, zLevel in pairs(self.activeChildren) do
        for _, child in pairs(zLevel) do
            local newPropertyTable = utils.deepCopy(propertyTable)
            if child.parentObj.__type == enum.classType.renderable then
                ---@diagnostic disable-next-line: param-type-mismatch
                child.parentObj:render(newPropertyTable)
            elseif child.parentObj.__type == enum.classType.interaction then
                ---@diagnostic disable-next-line: param-type-mismatch
                child.parentObj:tick(newPropertyTable)
            end
        end
    end
end

---@param self parentable
---@param child parentable
---@return boolean
function parentable:hasChild(child)
    return utils.find(self.children, child) ~= nil
end

-- parent actions on children

---@param self parentable
---@param child parentable
---@param active boolean
function parentable:setActiveOnChild(child, active)
    if not self:hasChild(child) then print("You are NOT the father! (this parentable is not a child of the parentable)") return end
    local changeInState = child.active ~= active
    if not changeInState then print("No change in active state!") return end
    child.active = active
    if active then
        self:register(child, child.zIndex)
    else
        self:unregister(child, child.zIndex)
    end
end

---@param self parentable
---@param child parentable
---@return integer, integer
function parentable:getZ(child)
    for z, objectsToRender in pairs(self.activeChildren) do
        local index = utils.find(objectsToRender, child)
        if not index then goto continue end
        do return z, index end
        ::continue::
    end
end

---@param self parentable
---@param child parentable
---@param newZ integer
---@param oldZ integer?
---@param oldIndex integer?
function parentable:changeZ(child, newZ, oldZ, oldIndex)
    if not self:hasChild(child) then print("You are NOT the father! (this parentable is not a child of the parentable)") return end
    if not oldZ then
        oldZ, oldIndex = self:getZ(child)
    elseif not oldIndex then
        oldIndex = utils.find(self.activeChildren[oldZ], child)
    end
    self:unregister(child, oldZ, oldIndex)
    self:register(child, newZ)
end

---hidden func, dont call ouside of class
---@param self parentable
---@param child parentable
---@param z integer
function parentable:register(child, z)
    if not self:hasChild(child) then print("You are NOT the father! (this parentable is not a child of the parentable)") return end
    if not self.activeChildren[z] then
        self.activeChildren[z] = {}
    else
        if self:getZ(child) then print("This object is already registered!") return end
    end
    table.insert(self.activeChildren[z], child)
end

---hidden func, dont call ouside of class
---@param self parentable
---@param child parentable
---@param z integer?
---@param index integer?
function parentable:unregister(child, z, index)
    if not self:hasChild(child) then print("You are NOT the father! (this parentable is not a child of the parentable)") return end
    if not z then
        z, index = self:getZ(child)
    elseif not index then
        index = utils.find(self.activeChildren[z], child)
    end
    if not index then print("This parentable is not active!") return end
    table.remove(self.activeChildren[z], index)
    if child.parentObj.__type == enum.classType.interaction then
        if child.parentObj.isInside then
            child.parentObj.isInside = false
            child.parentObj.hoverOffFunc()
        end
    end
    if #self.activeChildren[z] ~= 0 then return end
    table.remove(self.activeChildren, z)
end

-- self actions

---@param self parentable
---@param active boolean
function parentable:setActiveOnSelf(active)
    self.parentParentable:setActiveOnChild(self, active)
end

---@param self parentable
---@param parentParentable parentable
function parentable:setParent(parentParentable)
    parentParentable:addChildren({self})
end

---@param self parentable
---@param childrenParentables parentable[]
function parentable:addChildren(childrenParentables)
    for _, childToBeAdded in pairs(childrenParentables) do
        if utils.find(self.children, childToBeAdded) then goto continue end
        -- disconnect from old parent
        if childToBeAdded.parentParentable then
            childToBeAdded.parentParentable:unregister(childToBeAdded, childToBeAdded.zIndex)
            table.remove(childToBeAdded.parentParentable.children, utils.find(childToBeAdded.parentParentable.children, childToBeAdded))
        end

        -- connect to new parent
        childToBeAdded.parentParentable = self
        table.insert(self.children, childToBeAdded)
        if childToBeAdded.active then self:register(childToBeAdded, childToBeAdded.zIndex) end
        ::continue::
    end
end

---@class parentable
---@field __type "parentable"
---@field active boolean
---@field zIndex integer
---@field parentObj renderable | interaction
---@field parentParentable parentable?
---@field activeChildren table<integer, table<integer, parentable>>
---@field children parentable[]
---@field processAllChildren fun(self: parentable, propertyTable: table<string, any>)
---@field hasChild fun(self: parentable, child: parentable): boolean 
---@field setActiveOnChild fun(self: parentable, child: parentable, active: boolean)
---@field getZ fun(self: parentable, child: parentable): number, number
---@field changeZ fun(self: parentable, child: parentable, newZ: integer, oldZ: integer?, oldIndex: integer?)
---@field register fun(self: parentable, child: parentable, z: integer) 
---@field unregister fun(self: parentable, child: parentable, z: integer?, index: integer?) 
---@field setActiveOnSelf fun(self: parentable, active: boolean)
---@field setParent fun(self: parentable, parentParentable: parentable)
---@field addChildren fun(self: parentable, childrenParentables: parentable[])
return parentable