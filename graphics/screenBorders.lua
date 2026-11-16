local screenBorders = {}

local vector2 = require("engineBase.classes.vector2")
local globals = require("utils.globals")
local scriptUtils = require("engineBase.utils")
local screenData = require("classes.structs.screenData")

---@return screenData
function screenBorders.getScreenOffset()
    local xSize, ySize = love.graphics.getDimensions()

    local calculatedXWdith = globals.aspectRatio * ySize
    local xExcess = xSize - calculatedXWdith
    xExcess = scriptUtils.clamp(xExcess, 0, math.huge)

    local calculatedYHeight = 1/globals.aspectRatio * xSize
    local yExcess = ySize - calculatedYHeight
    yExcess = scriptUtils.clamp(yExcess, 0, math.huge)

    local vertBarWidth = xExcess/2
    local horizBarHeight = yExcess/2

    
    local screenPos = vector2.new(vertBarWidth, horizBarHeight)
    local screenSize = vector2.new(xSize - xExcess, ySize - yExcess)
    local vertBarSize = vector2.new(vertBarWidth, ySize)
    local HorizBarSize = vector2.new(screenSize.x, horizBarHeight)

    return screenData.packageData(screenPos, screenSize, vertBarSize, HorizBarSize)
end

---@param currentScreenData screenData
function screenBorders.drawBorders(currentScreenData)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", currentScreenData.leftBar.pos.x, currentScreenData.leftBar.pos.y, currentScreenData.leftBar.size.x, currentScreenData.leftBar.size.y)
    love.graphics.rectangle("fill", currentScreenData.rightBar.pos.x, currentScreenData.rightBar.pos.y, currentScreenData.rightBar.size.x, currentScreenData.rightBar.size.y)
    love.graphics.rectangle("fill", currentScreenData.topBar.pos.x, currentScreenData.topBar.pos.y, currentScreenData.topBar.size.x, currentScreenData.topBar.size.y)
    love.graphics.rectangle("fill", currentScreenData.bottomBar.pos.x, currentScreenData.bottomBar.pos.y, currentScreenData.bottomBar.size.x, currentScreenData.bottomBar.size.y)
end

return screenBorders