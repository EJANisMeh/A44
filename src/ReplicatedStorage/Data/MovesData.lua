-- commented out since not currently used
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local animationsData = require(ReplicatedStorage.Data:WaitForChild("AnimationsData"))
local kill = 1

-- maybe for future use
-- local ClassData = {}

-- ClassData["HolyStrike"] = {
-- 	M1Animation = "rbxassetid://82989510582963" ,
-- 	cooldown = 3 ,
-- 	damage = 4,
-- }

-- ClassData["DarkSlash"] = {
	
-- }

-- ClassData["WindBlade"] = {
-- 	damage = 3,
-- 	cooldown = 2
-- }

-- ClassData["TheReaper"] = {
-- 	damage = 10,
-- 	cooldown = (kill == true and 0 or nil)
-- }

-- ClassData["Reaper's Execution"] = {
-- 	damage = 30,
-- 	energy = 6,
-- 	cooldown = 7
-- }

-- ClassData["Tainted Blade"] = {
-- 	damage = 15,
-- 	energy = 3,
-- 	cooldown = 4
-- }

-- moves

return {
	ClassMoves = {
		Scythe = { 
			{
				name = "Reaper's Execution",
				M1Animation = "132446575429090",
				damage = 30,
				energy = 6,
				cooldown = 7
			},
			{
				name = "The Reaper",
				damage = 10,
				cooldown = (kill == true and 0 or nil)
			},
			{
				name = "Wind Blade"
			},
			{
				name = "Tainted Blade"
			}
		}
	}
}
