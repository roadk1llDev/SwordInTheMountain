local fileData = love.filesystem.newFileData("images/cursor.png")
local newCursor = love.mouse.newCursor(fileData,2,12)
love.mouse.setCursor(newCursor)