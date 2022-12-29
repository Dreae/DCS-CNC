---@class warehouse
local warehouse = {}

---@param unit any
---@return warehouse
function warehouse:new(unit)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.team = unit:GetCoalition()
    return o
end

return warehouse