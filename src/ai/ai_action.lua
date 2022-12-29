---@class task_plan
---@field required_assets {[asset_class]: capabilities[]}


---@class ai_action
---@field utility_function fun(taccom: taccom): number, task_plan?
---@field ap_cost number
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

return ai_action