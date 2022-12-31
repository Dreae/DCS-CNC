local capabilities = require("command.capabilities")
local warehouse = require("command.warehouse")
local taskable = require("command.taskable")
local squadron = require("command.squadron")
local ai_action= require("ai.ai_action")

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

---@param required_capabilities capabilities[]
function airwing:has_available_assets(required_capabilities)
    for _, squad in pairs(self.squadrons) do
        local capable = true
        for _, required_capability in ipairs(required_capabilities) do
            if not squad:is_capable(required_capability) then
                capable = false
            end
        end
        if capable then
            return true
        end
    end
end

---@param task_plan task_plan
---TODO: Refactor
function airwing:add_task_plan(task_plan)
    self:add_task(function()
        local spawns = task_plan._partial_spawn or {}
        for _, required_capability in pairs(task_plan.required_assets[ai_action.asset_class.Air]) do
            if not spawns[required_capability] then
                local squad = self:get_capable_squadron(required_capability)

                local spawned_group = squad:get_spawn(required_capability):SpawnAtAirbase(self.airbase)

                if spawned_group ~= nil then
                    spawns[required_capability] = spawned_group
                else
                    task_plan._partial_spawn = spawns
                    return taskable.task_result.Retry
                end
            end
        end
        task_plan:task_assets(self.taccom, ai_action.asset_class.Air, spawns)
        for _, group in pairs(spawns) do
            group:SetAIOn()
        end
        return taskable.task_result.Done
    end)
end

return airwing