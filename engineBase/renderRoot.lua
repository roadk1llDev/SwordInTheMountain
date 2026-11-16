local renderRoot = {}

local parentable = require("engineBase.classes.parentable")
local interaction = require("engineBase.classes.interaction")

renderRoot.rootParentable = parentable.new(true, 0)

---@param canvasWindowData windowData
---@param mousePos vector2
---@param click boolean
function renderRoot.processAll(canvasWindowData, mousePos, click)

    local propertyTable = {
        windowDataObj = canvasWindowData,
        mousePos = mousePos,
        click = click
    }

    renderRoot.rootParentable:processAllChildren(propertyTable)
    if interaction.hasClickedOnSomething then interaction.hasClickedOnSomething = false end
end

return renderRoot