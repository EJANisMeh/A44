local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animationsData = require(ReplicatedStorage.Data:WaitForChild("AnimationsData"))

-- class data
return {
	["Scythe"] = {
		M1Animation = animationsData["Scythe"].M1Animation,
		OwAtkCooldown = 1,
		OwAtkDelay = 0.2,
		owAtkAnimDmgStart = 0.14,
		owAtkAnimDmgEnd = 0.38,
		SheateCooldown = 1,
		WeaponName = "Scythe",
		WeaponHeld = "Right",
	},

	["Monk"] = {
		
	},
}
