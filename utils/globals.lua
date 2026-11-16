local globals = {}

globals.isBuild = false
globals.windowName = "epic gamae with epic gameolayer!!"
globals.isFullscreen = false
globals.time = 0
globals.aspectRatio = 5/4

---@param dt number
function globals.updateTime(dt)
    globals.time = globals.time + dt
end

return globals