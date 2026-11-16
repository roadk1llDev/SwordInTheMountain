local INCLUDE_DEBUG_VISUALS = true
local CLICKS_CAN_PIERCE_INTERACTIONS = true

-- engine base:
local globals = require("utils.globals")
local utils = require("engineBase.utils")
local renderRoot = require("engineBase.renderRoot")
local renderable = require("engineBase.classes.renderable")
local rectangle = require("engineBase.classes.rectangle")
local image = require("engineBase.classes.image")
local color = require("engineBase.classes.color")
local guiBase = require("engineBase.classes.guiBase")
local sc2d = require("engineBase.classes.sc2d")
local vector2 = require("engineBase.classes.vector2")
local interaction = require("engineBase.classes.interaction")
local debugShowVisuals = require("engineBase.debugShowVisuals")
local parentable = require("engineBase.classes.parentable")
local interactionHandler = require("engineBase.interactionHandler")

-- game:
local playerClass = require("classes.player")
local location = require("classes.location")

local screenBorders = require("graphics.screenBorders")

require("misc.setUpData")
require("misc.setUpCursor")

local player
local currentScreenData

local handSize = 0.4
local scaleSize = 0.05
local leftHandPos = vector2.new(0 - scaleSize, 1 + scaleSize)
local rightHandPos = vector2.new(1 - handSize, 1) + scaleSize

-- local backgroundParentable = parentable.new(true, 1)
-- local handsParentable = parentable.new(true, 2)

-- local rightHand = image.new(love.graphics.newImage("images/hand.png"), renderable.new(color.none(1), parentable.new(true, 1), guiBase.new(sc2d.fromScale(rightHandPos:unpack()), sc2d.fromScale(-handSize, handSize), vector2.new(1, 1))))
-- local leftHand = image.new(love.graphics.newImage("images/hand.png"), renderable.new(color.none(1), parentable.new(true, 1), guiBase.new(sc2d.fromScale(leftHandPos:unpack()), sc2d.fromScale(handSize, handSize), vector2.new(0, 1))))

-- local jonk = image.new(location.currentLocation.image, renderable.new(color.none(1), parentable.new(true, 1), guiBase.new(sc2d.fromScale(0.5, 0.5), sc2d.fromScale(1.2, 1.2), vector2.new(0.5, 0.5))))
-- local jonk2 = image.new(love.graphics.newImage("images/locations/branchingHalls/leftHighlight.png"), renderable.new(color.none(1), parentable.new(true, 2), guiBase.new(sc2d.fromScale(0.5, 0.5), sc2d.fromScale(1.2, 1.2), vector2.new(0.5, 0.5))))

-- local interactionGuiBase = guiBase.new(sc2d.fromScale(0.5, 0.5),sc2d.new(0, 100, 0.5, 50),vector2.new(0.5, 0.5))
-- local upToYouGuys = interaction.new(parentable.new(true, 1), interactionGuiBase, INCLUDE_DEBUG_VISUALS)
-- local cogBog = rectangle.new(renderable.new(color.rgba(127, 255, 127, 1), parentable.new(true, 2), interactionGuiBase))

-- renderRoot.rootParentable:addChildren({backgroundParentable, handsParentable})

-- handsParentable:addChildren({rightHand.renderable.parentableObj, leftHand.renderable.parentableObj})
-- backgroundParentable:addChildren({jonk.renderable.parentableObj, jonk2.renderable.parentableObj})

-- rightHand.renderable.parentableObj:setParent(handsParentable)
-- upToYouGuys.parentableObj:setParent(rightHand.renderable.parentableObj)
-- cogBog.renderable.parentableObj:setParent(rightHand.renderable.parentableObj)

-- upToYouGuys.hoverOnFunc = function()
--     print("hi")
-- end

-- upToYouGuys.hoverOffFunc = function()
--     print("bye")
-- end

-- upToYouGuys.clickFunc = function()
--     print("me when I click on the thing lol")
-- end

local background = rectangle.new(renderable.new(color.none(1), parentable.new(true, 0), guiBase.new(sc2d.fromScale(0.5, 0.5), sc2d.fromScale(1, 1), vector2.new(0.5, 0.5))))

-- local bold = rectangle.new(renderable.new(color.rgba(255, 0, 0, 1), parentable.new(true, 2), guiBase.new(sc2d.fromScale(0.5, 0.5), sc2d.fromScale(0.75, 0.75), vector2.new(0.5, 0.5))))
-- local brash = rectangle.new(renderable.new(color.rgba(0, 255, 100, 1), parentable.new(true, 1), guiBase.new(sc2d.fromOffset(10, 20), sc2d.fromOffset(200, 200), vector2.new(0, 0))))

-- background.renderable.parentableObj:setParent(renderRoot.rootParentable)
-- bold.renderable.parentableObj:setParent(renderRoot.rootParentable)
-- brash.renderable.parentableObj:setParent(bold.renderable.parentableObj)

local sharedGuiBase = guiBase.new(sc2d.fromOffset(0, 0), sc2d.fromScale(0.95, 0.95), vector2.new(0, 0))
local previousRectangle
local newInteraction
local specialGuy

local obma = love.graphics.newImage("engineBase/keystone.jpg")

renderRoot.rootParentable:addChildren({background.renderable.parentableObj})
for i = 1, 100 do
    local newRectangle = interaction.new(false, --[[obma, renderable.new(color.new(math.sqrt(love.math.random()), math.sqrt(love.math.random()), math.sqrt(love.math.random()), 1),]] parentable.new(true, 2), sharedGuiBase, INCLUDE_DEBUG_VISUALS)
    if previousRectangle then
        newRectangle.parentableObj:setParent(previousRectangle.parentableObj)
    else
        newRectangle.parentableObj:setParent(renderRoot.rootParentable)

        newRectangle.clickFunc = function()
            print("bad ending")
        end

    end
    previousRectangle = newRectangle

    if i == 11 then
        newInteraction = interaction.new(true, parentable.new(true, 1), guiBase.new(sc2d.fromScale(0, 0), sc2d.fromScale(1, 1), vector2.zero()), INCLUDE_DEBUG_VISUALS)

        newInteraction.hoverOnFunc = function()
            print("hi")
        end

        newInteraction.hoverOffFunc = function()
            print("bye")
        end

        newInteraction.clickFunc = function()
            print("me when I click on the thing lol")
        end

        newInteraction.parentableObj:setParent(newRectangle.parentableObj)
    elseif i == 70 then
        specialGuy = newRectangle
    end
end

utils.printTable(newInteraction)

function love.load()
    love.graphics.setDefaultFilter("linear", "linear")

    player = playerClass.new()
end

local done = false
local sharedGuiWiggleRoom = 1 - sharedGuiBase.size.scale.x
function love.update(dt)
    -- update gametime (based off of window open time, not main time. For main time, use love.timer.getTime())
    globals.updateTime(dt)

    currentScreenData = screenBorders.getScreenOffset()

    local mousePos = vector2.new(love.mouse.getPosition())

    ---- custom garbo ----

    local x = (math.cos(globals.time)+1)/2
    local y = (math.sin(globals.time)+1)/2

    sharedGuiBase.pos = sc2d.fromScale(x * sharedGuiWiggleRoom, y * sharedGuiWiggleRoom)

    if globals.time > 100 and not done then
        done = true
        newInteraction.parentableObj:setActiveOnSelf(false)
        specialGuy.parentableObj:setParent(renderRoot.rootParentable)
        -- renderRoot.rootParentable:setActive(upToYouGuys.parentableObj, false)
    end

    -- -------- jonk
    -- ---@cast jonk image

    -- -- move ts into another fucking thingy yeah
    -- -- calc new mouse pos
    -- local mousePercent = sc2d.convertPixelToLocalScale(vector2.new(love.mouse.getPosition()), currentScreenData.centerImage, true)

    -- mousePercent = (mousePercent - 0.5) * 2
    -- mousePercent = -vector2.new(utils.clamp(mousePercent.x, -1, 1), utils.clamp(mousePercent.y, -1, 1))
    -- local endMousePos = vector2.new(0.5 + mousePercent.x * 0.1, 0.5 + mousePercent.y * 0.1)

    -- -- larp
    -- local tAdj = 1-(0.005^dt)
    -- local finalThingImTooTiredToNameGood = jonk.renderable.guiBase.pos.vectorScale:larp(endMousePos, tAdj)
    -- local jonkGuiPos = sc2d.fromScale(finalThingImTooTiredToNameGood.x, finalThingImTooTiredToNameGood.y)
    -- jonk.renderable.guiBase.pos = jonkGuiPos
    -- jonk2.renderable.guiBase.pos = jonkGuiPos
    -- -------- jonk

    -- -------- hands

    -- local endLeftHandPos = leftHandPos + mousePercent * 0.025
    -- local endRightHandPos = rightHandPos + mousePercent * 0.025

    -- -- larp
    -- local tAdj2 = 1-(0.01^dt)
    -- local finalFinalThingImTooTiredToNameGood = leftHand.renderable.guiBase.pos.vectorScale:larp(endLeftHandPos, tAdj2)
    -- local finalFinalThingImTooTiredToNameGood2 = rightHand.renderable.guiBase.pos.vectorScale:larp(endRightHandPos, tAdj2)
    -- leftHand.renderable.guiBase.pos = sc2d.fromScale(finalFinalThingImTooTiredToNameGood.x, finalFinalThingImTooTiredToNameGood.y)
    -- rightHand.renderable.guiBase.pos = sc2d.fromScale(finalFinalThingImTooTiredToNameGood2.x, finalFinalThingImTooTiredToNameGood2.y)

    -- -------- hands

end

function love.draw()
    interactionHandler.resetStack(CLICKS_CAN_PIERCE_INTERACTIONS)

    renderRoot.processAll(currentScreenData.centerImage, vector2.new(love.mouse.getPosition()), false)
    screenBorders.drawBorders(currentScreenData)
    interactionHandler.processStack(INCLUDE_DEBUG_VISUALS)

    if INCLUDE_DEBUG_VISUALS then
        debugShowVisuals.renderAll()
    end
end

function love.mousepressed(x, y, button, istouch)
    local absMousePos = vector2.new(x, y)
    if button ~= 1 and not istouch then return end
    interactionHandler.resetStack(CLICKS_CAN_PIERCE_INTERACTIONS)
    renderRoot.processAll(currentScreenData.centerImage, absMousePos, true)
    interactionHandler.processStack(false)
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "f11" then
        globals.isFullscreen = not globals.isFullscreen
        love.window.setFullscreen(globals.isFullscreen)
    end
end