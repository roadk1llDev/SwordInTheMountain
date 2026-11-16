local location = {}

location.registeredLocations = {}
location.currentLocation = nil

location.__index = location

---@param name string
---@param imagePath string
---@return location
function location.new(name, imagePath)
    local self = setmetatable({}, location)

    self.name = name
    self.image = love.graphics.newImage(imagePath)

    if location.registeredLocations[name] then
        print("holy fucking shit, a location by the name of "..name.." exists already!!1! (asshole)")
    end
    location.registeredLocations[name] = self
    return self
end

function location:setActive(status)
    
end

---@class location
---@field name string
---@field image loveImageObject
return location