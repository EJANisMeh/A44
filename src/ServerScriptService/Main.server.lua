-- for initializing core systems
local ServerScriptService = game:GetService("ServerScriptService")

local CombatSystem = require(ServerScriptService.Combat:WaitForChild("CombatSystem"))
local EnvironmentSystem = require(ServerScriptService.Environment:WaitForChild("EnvironmentSystem"))


CombatSystem:Init()
EnvironmentSystem:Init()