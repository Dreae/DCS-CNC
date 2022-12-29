local ai_action = require("ai.ai_action")
local capabilities = require("command.capabilities")

---@type ai_action
local ai_action_launch_awacs = {
    ap_cost = 12,
    utility_function = function (taccom)
        local awacs = taccom:get_assets_on_station(capabilities.AWACS)
        if #awacs == 0 then
            return 1.0, {
                required_assets = {[ai_action.asset_class.Air] = {capabilities.AWACS}}
            }
        end
        return 0.0, nil
    end,
}

return ai_action_launch_awacs