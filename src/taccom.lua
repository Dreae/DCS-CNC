local settings = require("presets.init")
local airwing = require("command.airwing")
local ai_action    = require("ai.ai_action")

---@class taccom
---@field team number
---@field airwings table<number, airwing>
---@field navmesh navmesh
---@field airbosses any[]
---@field callsigns string[]
---@field assets_on_station table<capabilities, table>
---@field action_tokens number
---@field utility_threshold number
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
    o.assets_on_station = {}
    o.utility_threshold = 0.25
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

function taccom:remove_dead_assets()
    for capability, assets in pairs(self.assets_on_station) do
        local alive_assets = {}
        for _, group in ipairs(assets) do
            if group:IsAlive() then
                table.insert(alive_assets, group)
            end
        end

        self.assets_on_station[capability] = alive_assets
    end
end

---@type ai_action[]
local actions = {
    require("ai.launch_awacs")
    --require("ai.wait_for_ap")
}
function taccom:think()
    self:remove_dead_assets()

    ---@type ai_action|number[]
    local action_utilities = {}
    for _, action in ipairs(actions) do
        if self.action_tokens > action.ap_cost then
            table.insert(action_utilities, {action, action:utility(self)})
        end
    end
    table.sort(action_utilities, function (a, b) return a[2] < b[2] end)
    local utility = action_utilities[1][2]
    if utility < self.utility_threshold then return end

    local action = action_utilities[1][1]
    local task_plan = action.task_plan(self)
    local taskables = self:available_assets(task_plan.required_assets)
    if taskables == nil then
    else
        --TODO: Sort by suitability for task (distance, airframe performance, etc.)
        local taskable = taskables[1]
        taskable:add_task_plan(task_plan)
    end
end

function taccom:get_assets_on_station(capability)
    return self.assets_on_station[capability] or {}
end

function taccom:add_asset_on_station(group, capability)
    if self.assets_on_station[capability] == nil then
        self.assets_on_station[capability] = {group}
    else
        table.insert(self.assets_on_station[capability], group)
    end
end

---@param required_assets required_assets
---@return taskable[]?
function taccom:available_assets(required_assets)
    local taskables = {}
    for asset_class, required_capabilities in pairs(required_assets) do
        if asset_class == ai_action.asset_class.Air then
            for _, wing in pairs(self.airwings) do
                if wing:has_available_assets(required_capabilities) then
                    table.insert(taskables, wing)
                end
            end
        elseif asset_class == ai_action.asset_class.Land then
            return nil
        elseif asset_class == ai_action.asset_class.Ship then
            return nil
        end
    end

    return taskables
end

return taccom