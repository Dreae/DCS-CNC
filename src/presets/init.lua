local preset_red = require("presets.red")
local preset_blue = require("presets.blue")

---@class airframe
---@field capabilities table<capabilities, number>
---@field loadouts table<capabilities, string>

---@class squadron
---@field airframe airframe
---@field count number
---@field callsign ?string
---@field livery ?string

---@class settings
---@field callsigns table<number, string>
---@field navy table<number, wing>
---@field airforce table<number, wing>

---@class wing
---@field squadrons table<string, squadron>

---@return table<string, settings>
return {red = preset_red, blue = preset_blue}