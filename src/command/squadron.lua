local taskable = require("command.taskable")

---@class squadron : taskable
---@field loadouts table<capabilities, any>
local squadron = taskable:new()

---@param callsign string
---@param airframe airframe
---@return squadron
function squadron:new(team, callsign, airframe)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.loadouts = {}
    for capability, loadout in pairs(airframe.loadouts) do
        local spawn = SPAWN:NewWithAlias(loadout, callsign)
        spawn:InitAIOff()
        spawn:InitCoalition(team)
        if team == coalition.side.BLUE then
            spawn:InitCountry(country.id.USA)
        else
            spawn:InitCountry(country.id.RUSSIA)
        end
        o.loadouts[capability] = spawn
    end

    return o
end

---@param capability capabilities
---@return boolean
function squadron:is_capable(capability)
    return self.loadouts[capability] ~= nil
end

---@param capability capabilities
---@return any
function squadron:get_spawn(capability)
    return self.loadouts[capability]
end


return squadron