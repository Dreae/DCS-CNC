---@alias required_assets {[asset_class]: capabilities[]}

---@class task_plan
---@field required_assets required_assets
---@field start_point point
---@field task_assets fun(self: task_plan, taccom: taccom, asset_class: asset_class, group: {[capabilities]: any})

---@class ai_action_definition
---@field utility_function fun(taccom: taccom): number
---@field task_plan fun(taccom: taccom): task_plan
---@field curve fun(x: number): number
---@field ap_cost number

---@class ai_action : ai_action_definition
---@field utility fun(self: ai_action, taccom: taccom): number
local ai_action = {}

---@type table<string, fun(number): number>
local curves = {
    curve_linear = function (x)
        return x
    end,
}
ai_action.curves = curves

---@enum asset_class string
local asset_class = {
    Air = "Air",
    Land = "Land",
    Ship = "Ship"
}
ai_action.asset_class = asset_class

---@param object ai_action_definition
---@return ai_action
function ai_action:new(object)
    local o = object or {}
    setmetatable(o, self)
    self.__index = self

    ---@cast o ai_action
    return o
end

---@param taccom taccom
---@return number
function ai_action:utility(taccom)
    return self.curve(self.utility_function(taccom))
end

return ai_action