local player = {}
local customEnum = require("utils.customEnum")

player.__index = player

---@return player
function player.new()
    local self = setmetatable({}, player)

    self.leftEquipment = customEnum.playerEquipment.nothing
    self.rightEquipment = customEnum.playerEquipment.nothing

    return self
end

---@class player
---@field leftEqiupment playerEquipment
---@field rightEquipment playerEquipment
return player