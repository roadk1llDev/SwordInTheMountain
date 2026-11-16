local screenData = {}

local vector2 = require("engineBase.classes.vector2")
local windowData = require("engineBase.structs.windowData")

---@param centerPos vector2
---@param centerSize vector2
---@param verticalBarSize vector2
---@param horizontalBarSize vector2
---@return screenData
function screenData.packageData(centerPos, centerSize, verticalBarSize, horizontalBarSize)
    local leftBarPos = vector2.zero()
    local rightBarPos = vector2.new(centerSize.x + centerPos.x, 0)
    local topBarPos = vector2.new(centerPos.x, 0)
    local bottomBarPos = vector2.new(centerPos.x, centerSize.y + centerPos.y)

    return {
        centerImage = windowData.new(centerPos, centerSize),
        leftBar = windowData.new(leftBarPos, verticalBarSize),
        rightBar = windowData.new(rightBarPos, verticalBarSize),
        topBar = windowData.new(topBarPos, horizontalBarSize),
        bottomBar = windowData.new(bottomBarPos, horizontalBarSize)
    }
end

---@class screenData
---@field centerImage windowData
---@field leftBar windowData
---@field rightBar windowData
---@field topBar windowData
---@field bottomBar windowData
return screenData