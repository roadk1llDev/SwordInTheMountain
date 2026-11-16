local interactionHandler = {}

local debugShowVisuals = require("engineBase.debugShowVisuals")

interactionHandler.stack = {}
interactionHandler.canHover = true
interactionHandler.canPierce = false

---@param canPierce boolean
function interactionHandler.resetStack(canPierce)
    interactionHandler.hasClickedOnSomething = false
    interactionHandler.canHover = true
    interactionHandler.canPierce = canPierce
    interactionHandler.stack = {}
end

---@param interaction interaction
---@param isMouseWithinBounds boolean
---@param click boolean
---@param windowData windowData
function interactionHandler.addToStack(interaction, isMouseWithinBounds, click, windowData)
    local packedStackData = {
        interaction = interaction,
        isMouseWithinBounds = isMouseWithinBounds,
        click = click,
        windowData = windowData
    }

    table.insert(interactionHandler.stack, packedStackData)
end

---@param renderDebugVisuals boolean
function interactionHandler.processStack(renderDebugVisuals)
    for i = #interactionHandler.stack, 1, -1 do

        ---@type {interaction: interaction, isMouseWithinBounds: boolean, click: boolean, windowData: windowData}
        local stackData = interactionHandler.stack[i]
        local interaction = stackData.interaction
        local isMouseWithinBounds = stackData.isMouseWithinBounds
        local click = stackData.click
        local windowData = stackData.windowData

        if not interaction.isInside and isMouseWithinBounds and interactionHandler.canHover then
            interaction.isInside = true
            interaction.hoverOnFunc()
        elseif interaction.isInside and (not isMouseWithinBounds or not interactionHandler.canHover) then
            interaction.isInside = false
            interaction.hoverOffFunc()
        end

        
        if not click and renderDebugVisuals then
            debugShowVisuals.queueOutline(interaction, windowData)
        end
        -- click
        if click then
            if interaction.isInside then
                if (interactionHandler.canPierce or not interactionHandler.hasClickedOnSomething) and interactionHandler.canHover then
                    interaction.clickFunc()
                    interactionHandler.hasClickedOnSomething = true
                end
            end
        end
        
        if interaction.isInside and interaction.blocksHover then
            interactionHandler.canHover = false
        end
    end

    interactionHandler.stack = {}
end

return interactionHandler