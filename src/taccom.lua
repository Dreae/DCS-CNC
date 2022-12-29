local settings = require("presets.init")
local airwing = require("command.airwing")
local capabilities = require("command.capabilities")

---@class taccom
---@field team number
---@field airwings table<number, airwing>
---@field navmesh navmesh
---@field airbosses any[]
---@field callsigns string[]
---@field assets_on_station table<capabilities, table>
local taccom = {}

---Create new taccom instance
---@return taccom
function taccom:new(team, navmesh)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.team = team
    o.airwings = {}
    o.airbosses = {}
    o.navmesh = navmesh
    o.action_tokens = 32
    return o
end

function taccom:start()
    local preset = nil
    if self.team == coalition.side.BLUE then
        preset = settings.blue
    else
        preset = settings.red
    end
    self.callsigns = preset.callsigns

    for _, airbase in pairs(AIRBASE.GetAllAirbases(self.team)) do
        local wing_preset
        if airbase:GetAirbaseCategory() == Airbase.Category.SHIP then
            local airboss = AIRBOSS:New(airbase:GetName())
            if airboss ~= nil then
                airboss:Start()
                table.insert(self.airbosses, airboss)
            end

            wing_preset = preset.navy.wings[math.random(#preset.navy.wings)]
        else
            wing_preset = preset.airforce.wings[math.random(#preset.airforce.wings)]
        end

        local wing = airwing:new(self, airbase:GetName(), wing_preset)
        table.insert(self.airwings, wing)
    end

    self.timer = TIMER:New(function ()
        self:think()
    end)
    self.timer:Start(nil, 2.0)
end

function taccom:reserve_callsign()
    return table.remove(self.callsigns, math.random(#self.callsigns))
end

function taccom:release_callsign(callsign)
    table.insert(self.callsigns, callsign, math.random(#self.callsigns))
end

---@type ai_action[]
local actions = {
    require("ai.launch_awacs")
}
function taccom:think()
    ---@type {[number]: number|ai_action}[]
    local action_utilities = {}
    for _, action in ipairs(actions) do
        table.insert(action_utilities, {action, action.utility_function(self)})
    end
    table.sort(action_utilities, function (a, b) return a[2] < b[2] end)

    for _, action_utility in ipairs(action_utilities) do
        local action = action_utility[1]
        local required_assets = action.required_assets(self)
        for asset_class, required_capability in pairs(required_assets) do
            if type(required_capability) == "function" then

            else

            end
        end
    end
end

function taccom:get_assets_on_station(capability)
    return self.assets_on_station[capability] or {}
end

return taccom