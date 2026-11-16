local utils = {}

local engineGlobals = require("engineBase.engineGlobals")

---@param x number
---@param min number
---@param max number
---@return number
function utils.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

---@param t table
---@param instance any
---@return integer
function utils.find(t, instance)
    for i, v in pairs(t) do
        if v ~= instance then goto continue end
        do return i end
        ::continue::
    end
end

---@param a number
---@param b number
---@param t number
---@return number
function utils.larp(a, b, t)
    return a + (b-a) * t
end

---uses >= and <= (not strict)
---@param number number
---@param bound1 number
---@param bound2 number
---@return boolean
function utils.isWithin(number, bound1, bound2)
    local min = bound1 <= bound2 and bound1 or bound2
    local max = bound1 >= bound2 and bound1 or bound2
    return min <= number and number <= max
end

---@param t table
---@param indent integer?
---@param parentTables table[]?
---@return string
local function tableToString(t, indent, parentTables)
    
    if not indent then indent = 0 end
    if not parentTables then parentTables = {} end

    local currentTableString = "{\n"
    indent = indent + engineGlobals.indent
    for k, v in pairs(t) do
        currentTableString = currentTableString .. string.rep(" ", indent)

        -- key
        if type(k) == "number" then
            currentTableString = currentTableString .. "[" .. k .. "] = "
        elseif type(k) == "string" then
            currentTableString = currentTableString .. k .. " = "
        end

        -- value
        if type(v) == "string" then
            currentTableString = currentTableString .. "\"".. v .."\""
        elseif type(v) == "table" then
            for _, table in pairs(parentTables) do
                if v == table then
                    currentTableString = currentTableString .. "** Cyclic Reference (I'll melt you) **"
                    goto cyclicEnd
                end
            end
            table.insert(parentTables, v)
            currentTableString = currentTableString .. tableToString(v, indent, parentTables)
            table.remove(parentTables, utils.find(parentTables, v))
        else
            currentTableString = currentTableString .. tostring(v)
        end
        ::cyclicEnd::
        currentTableString = currentTableString .. ",\n"
    end
    indent = indent - engineGlobals.indent
    currentTableString = currentTableString .. string.rep(" ", indent) .. "}"
    return currentTableString
end

---@param t table
function utils.printTable(t)
    print(tableToString(t))
end

---@param t table
---@return table
function utils.deepCopy(t)
    local newTab = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            newTab[k] = utils.deepCopy(v)
        else
            newTab[k] = v
        end
    end

    setmetatable(newTab, getmetatable(t))

    return newTab
end

return utils