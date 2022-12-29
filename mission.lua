local taccom = require("taccom")
local navmesh = require("navmesh")

local navmesh = navmesh:new()
BlueTACCOM = taccom:new(coalition.side.BLUE, navmesh)
RedTACCOM = taccom:new(coalition.side.RED, navmesh)

BlueTACCOM:start()
RedTACCOM:start()