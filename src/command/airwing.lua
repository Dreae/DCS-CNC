local capabilities = require("command.capabilities")
local warehouse = require("command.warehouse")
local taskable = require("command.taskable")
local squadron = require("command.squadron")

---@class airwing : taskable
---@field airbase any
---@field settings wing
---@field warehouse warehouse
---@field team number
---@field taccom taccom
---@field scheduler any
---@field squadrons table<number, squadron>
local airwing = taskable:new()

---@param taccom taccom
---@param airbase any
---@param settings wing
---@return airwing
function airwing:new(taccom, airbase, settings)
    local o = taskable:new()
    setmetatable(o, self)
    self.__index = self

    o.settings = settings
    o.airbase = AIRBASE:FindByName(airbase)
    o.warehouse = warehouse:new(o.airbase)
    o.taccom = taccom
    o.squadrons = {}
    for name, squad_settings in pairs(o.settings.squadrons) do
        o.squadrons[name] = squadron:new(taccom.team, o.taccom:reserve_callsign(), squad_settings.airframe)
    end

    ---@cast o airwing
    return o
end

---@param capability capabilities
---@return squadron
function airwing:get_capable_squadron(capability)
    local squads = {}
    for _, squad in pairs(self.squadrons) do
        if squad:is_capable(capability) then
            table.insert(squads, squad)
        end
    end

    return squads[math.random(#squads)]
end

function airwing:start_CAP(CAP_zone)
    self:add_task(function()
        local squad = self:get_capable_squadron(capabilities.CAP)

        local spawned_group = squad:get_spawn(capabilities.CAP):SpawnAtAirbase(self.airbase, SPAWN.Takeoff.Hot, nil, nil, false)
        if spawned_group == nil then
            return taskable.task_result.Retry
        else
            local tasks = {}
            local CAP_coord = COORDINATE:NewFromVec2(CAP_zone:GetVec2())
            table.insert(tasks, CONTROLLABLE.EnRouteTaskEngageTargetsInZone(nil, CAP_zone:GetVec2(), 120000))
            table.insert(tasks, CONTROLLABLE.TaskOrbit(nil, CAP_coord, 7500, UTILS.KnotsToMps(350)))
            spawned_group:SetTask(CONTROLLABLE.TaskCombo(nil, tasks), 1)
            return taskable.task_result.Done
        end
    end)
end

return airwing