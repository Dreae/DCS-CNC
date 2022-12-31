local ai_action = require("ai.ai_action")
local capabilities = require("command.capabilities")
local utils = require("util.init")

---@class task_plan_awacs : task_plan
---@field pattern point[]
local task_plan_awacs = {}

---@class task_plan_haawacs : task_plan
---@field pattern point[]
local task_plan_haawacs = {}

---@type ai_action
local ai_action_launch_awacs = ai_action:new({
    ap_cost = 12,
    curve = ai_action.curves.curve_linear,
    utility_function = function (taccom)
        local awacs = taccom:get_assets_on_station(capabilities.AWACS)
        if #awacs == 0 then
            return 1.0
        end

        local ha_awacs = taccom:get_assets_on_station(capabilities.HAAWACS)
        if #ha_awacs == 0 then
            return 0.8
        end
        return 0.0
    end,
    task_plan = function (taccom)
        local awacs = taccom:get_assets_on_station(capabilities.AWACS)
        local midpoint = taccom.navmesh:get_midpoint()
        local team_midpoint = taccom.navmesh:get_midpoint(taccom.team)
        local v_midpoints = utils.vector:from_points(midpoint, team_midpoint)
        local v_normal = v_midpoints:normalized()
        assert(v_normal ~= nil)

        local v_rotated = utils.vector:new(v_normal.dy, -v_normal.dx)
        if #awacs == 0 then
            local v_scaled = v_rotated:multiply(30000)
            local offset = midpoint:add(v_normal:multiply(120000))

            local p = offset:subtract(v_scaled)
            local q = offset:add(v_scaled)
            return task_plan_awacs:new({p, q})
        else
            local v_scaled = v_rotated:multiply(60000)
            local offset = midpoint:add(v_normal:multiply(240000))

            local p = offset:subtract(v_scaled)
            local q = offset:add(v_scaled)
            return task_plan_haawacs:new({p, q})
        end
    end
})

---@param pattern point[]
function task_plan_awacs:new(pattern)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.pattern = pattern
    o.required_assets = {[ai_action.asset_class.Air] = {capabilities.AWACS}}
    return o
end

function task_plan_awacs:task_assets(taccom, asset_class, groups)
    for _capability, group in pairs(groups) do
        local tasks = {}
        local p = COORDINATE:NewFromVec2(self.pattern[1])
        local q = COORDINATE:NewFromVec2(self.pattern[2])
        table.insert(tasks, CONTROLLABLE.EnRouteTaskAWACS(nil))
        table.insert(tasks, CONTROLLABLE.TaskOrbit(nil, p, 6096, UTILS.KnotsToMps(250), q))
        group:SetTask(CONTROLLABLE.TaskCombo(nil, tasks), 1)
        taccom:add_asset_on_station(group, capabilities.AWACS)
    end
end

---@param pattern point[]
function task_plan_haawacs:new(pattern)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.pattern = pattern
    o.required_assets = {[ai_action.asset_class.Air] = {capabilities.HAAWACS}}
    return o
end

function task_plan_haawacs:task_assets(taccom, asset_class, groups)
    for _capability, group in pairs(groups) do
        local tasks = {}
        local p = COORDINATE:NewFromVec2(self.pattern[1])
        local q = COORDINATE:NewFromVec2(self.pattern[2])
        table.insert(tasks, CONTROLLABLE.EnRouteTaskAWACS(nil))
        table.insert(tasks, CONTROLLABLE.TaskOrbit(nil, p, 10668, UTILS.KnotsToMps(280), q))
        group:SetTask(CONTROLLABLE.TaskCombo(nil, tasks), 1)
        taccom:add_asset_on_station(group, capabilities.HAAWACS)
    end
end

return ai_action_launch_awacs