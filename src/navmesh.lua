local util = require("util.init")

---@class navmesh
---@field airbases table<string, any>
local navmesh = {}

---comment
---@return navmesh
function navmesh:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.airbases = {}
    o.control_zones = {}
    o:build()
    return o
end

function navmesh:build()
    env.info("Building navmesh")
    local control_zones = {}
    for _, zone in pairs(env.mission.triggers.zones) do
        if string.match(zone.name, "^CZ") and control_zones[zone.name] == nil then
            control_zones[zone.name] = ZONE:New(zone.name)
        end
    end

    local airbases = AIRBASE.GetAllAirbases(nil, Airbase.Category.AIRDROME)
    for _, zone in pairs(control_zones) do
        local airbase_distances = {}
        for _, airbase in pairs(airbases) do
            local distance = zone:Get2DDistance(airbase:GetVec2())
            table.insert(airbase_distances, {distance, airbase})
        end
        table.sort(airbase_distances, function (a, b) return a[1] < b[1] end)
        local parent_airbase = airbase_distances[1][2]
        if self.airbases[parent_airbase:GetName()] == nil then
            self.airbases[parent_airbase:GetName()] = {zone}
        else
            table.insert(self.airbases[parent_airbase:GetName()], zone)
        end
    end
end

---@param airbase_name ?string
---@return table<number, any>
function navmesh:get_control_zones(airbase_name)
    if airbase_name ~= nil then
        return UTILS.DeepCopy(self.airbases[airbase_name])
    end

    local zones = {}
    for _, zone_list in pairs(self.airbases) do
        for _, zone in pairs(zone_list) do
            table.insert(zones, zone)
        end
    end
    return zones
end

---@param team ?number
---@return point
function navmesh:get_midpoint(team)
    if team ~= nil then
        local avg_x, avg_y = 0.0, 0.0
        local airbases = AIRBASE.GetAllAirbases(team, Airbase.Category.AIRDROME)
        for _, airbase in pairs(airbases) do
            avg_x = avg_x + airbase:GetVec2().x
            avg_y = avg_y + airbase:GetVec2().y
        end
        avg_x = avg_x / #airbases
        avg_y = avg_y / #airbases

        return util.point:new(avg_x, avg_y)
    end
    local blue_midpoint = self:get_midpoint(coalition.side.BLUE)
    local red_midpoint = self:get_midpoint(coalition.side.RED)

    return util.point:new((blue_midpoint.x + red_midpoint.x) / 2, (blue_midpoint.y + red_midpoint.y) / 2)
end

return navmesh