---@alias task fun(): task_result

---@class taskable
---@field task_queue task[]
---@field timer any
---@field add_task fun(self: taskable, task: task)
---@field add_task_plan fun(self: taskable, task_plan: task_plan)
local taskable = {}

---@enum task_result
taskable.task_result = {
    Retry = 0,
    Done = 1
}

---@return taskable
function taskable:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.task_queue = {}
    return o
end

---@param task task
function taskable:add_task(task)
    table.insert(self.task_queue, task)
    self:start_timer()
end

function taskable:start_timer()
    if self.timer == nil then
        self.timer = TIMER:New(function ()
            self:run_queue()
        end)
        self.timer:Start(nil, 2.0)
    end
end

function taskable:run_queue()
    if #self.task_queue > 0 then
        local task = table.remove(self.task_queue, 1)
        local task_result = task()
        if task_result == taskable.task_result.Retry then
            self:add_task(task)
        end
    end
end

function taskable:add_task_plan(task_plan)
    env.error("Unimplemented")
end

return taskable