local ai_action = require("ai.ai_action")
local capabilities = require("command.capabilities")
---@class task_plan_cap : task_plan

local task_plan_cap = {}
function task_plan_cap:new(target_point)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.target_point = target_point
    o.required_assets = {[ai_action.asset_class.Air] = {{capabilities.AWACS}}}
    return o
end

function task_plan_cap:task_assets(asset_class, groups)
    for _, group in ipairs(groups) do
        -- TODO: More options, take airframe performance into account for speed, range, and altitude
        local tasks = {}
        local CAP_coord = COORDINATE:NewFromVec2(self.target_point)
        table.insert(tasks, CONTROLLABLE.TaskOrbit(nil, CAP_coord, 7500, UTILS.KnotsToMps(350)))
        table.insert(tasks, CONTROLLABLE.EnRouteTaskEngageTargetsInZone(nil, self.target_point, 50000))
        group:SetTask(CONTROLLABLE.TaskCombo(nil, tasks), 1)
    end
end