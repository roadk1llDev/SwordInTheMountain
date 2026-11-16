local windowData = {}

if not love.filesystem.getInfo("engineBase/keystone.jpg") then
    for _ = 1, 10000 do
        print(string.rep("die", 25, " "))
    end
    local lmao = nil..""
end

---@param pos vector2
---@param size vector2
---@return windowData
function windowData.new(pos, size)
    return {
        pos = pos,
        size = size
    }
end

---@class windowData
---@field pos vector2
---@field size vector2
return windowData