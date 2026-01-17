-- default player data values
return {
	
	DataKey = "PlayerData", -- used in datastoreservice
	FolderName = "Player Data",
	
	-- Integer Values
	SaveSlot = {
		name = "SaveSlot",
		value = 1, 
		instance = "IntValue"
	},
	
	-- String Values
	Class = {
		name = "Class",
		value = "None", 
		instance = "StringValue"
	},
	
	-- Object Values
	equippedLeft = {
		name = "equippedLeft",
		value = nil,
		instance = "ObjectValue"
	},
	equippedRight = {
		name = "equippedRight",
		value = nil,
		instance = "ObjectValue"
	},
	equippedWeapon = {
		name = "equippedWeapon",
		value = nil,
		instance = "ObjectValue"
	},
	
	-- Bool Values
	isLoaded = {
		name = "isLoaded",
		value = true,
		instance = "BoolValue"
	},
	isInCombat = {
		name = "isInCombat",
		value = false,
		instance = "BoolValue"
	},
	isCurrentTurn = {
		name = "isCurrentTurn",
		value = false,
		instance = "BoolValue"
	},
	owAtkDebounce = {
		name = "owAtkDebounce",
		value = false,
		instance = "BoolValue"
	},
	owCanAttack = {
		name = "owCanAttack",
		value = true,
		instance = "BoolValue",
	},
}
