local debugShowVisuals = {}

local color = require("engineBase.classes.color")

debugShowVisuals.scheduledRenders = {}

---@param colorObj color
---@param guiBase guiBase
local function drawLines(colorObj, guiBase, windowData)
    love.graphics.setColor(colorObj:unpack())

    local startPos = guiBase:getGlobalPixelPos(windowData)
    local endPos = startPos + guiBase.size:flushToOffset(windowData, false)

    love.graphics.line(
        startPos.x, startPos.y,
        endPos.x, startPos.y,
        endPos.x, endPos.y,
        startPos.x, endPos.y,
        startPos.x, startPos.y
    )
end

---@param colorObj color
---@param guiBase guiBase
---@param windowData windowData
---@return {color: color, guiBase: guiBase, windowData: windowData}
local function packData(colorObj, guiBase, windowData)
    return {
        color = colorObj,
        guiBase = guiBase,
        windowData = windowData
    }
end

---@param interaction interaction
---@param windowData windowData
function debugShowVisuals.queueOutline(interaction, windowData)
    if interaction.isInside then
        local packedData = packData(color.rgba(0, 255, 0, 1), interaction.guiBase, windowData)
        table.insert(debugShowVisuals.scheduledRenders, packedData)
    elseif interaction.parentableObj.active then
        local packedData = packData(color.rgba(255, 255, 0, 1), interaction.guiBase, windowData)
        table.insert(debugShowVisuals.scheduledRenders, packedData)
    else
        local packedData = packData(color.rgba(255, 0, 0, 1), interaction.guiBase, windowData)
        table.insert(debugShowVisuals.scheduledRenders, packedData)
    end
end

function debugShowVisuals.renderAll()
    for _, packedData in pairs(debugShowVisuals.scheduledRenders) do
        ---@cast packedData {color: color, guiBase: guiBase, windowData: windowData}
        drawLines(packedData.color, packedData.guiBase, packedData.windowData)
    end
    debugShowVisuals.scheduledRenders = {}
end

return debugShowVisuals