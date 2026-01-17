local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventDispatcher = require(ServerScriptService:WaitForChild("EventDispatcher")) -- Adjust path as needed

local CombatSystem = script.Parent.Parent
local OoCModule = require(CombatSystem:WaitForChild("Out-of-Combat"))

local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))

function regOwActionEventHandlers()
	-- Weapon sheating
	EventDispatcher:Register(eventsData.InputActions.Sheate, function(context)
		if context.isInCombat.Value then return end

		if not context.equippedWeapon.Value then
			-- Equip weapon
			OoCModule.unsheateWeapon(context.player, context.classInfo)
			if not context.equippedWeapon.Value then 
				warn("Unsheate Weapon failed for", context.player.Name) 
				return 
			end
			context.owCanAttack.Value = true
		else
			-- Unequip weapon
			OoCModule.sheateWeapon(context.player)
			context.owCanAttack.Value = false
		end
	end)

	-- Open world attacking
	EventDispatcher:Register(eventsData.InputActions.owAttack, function(context, timeStart, animLength)
		if context.isInCombat.Value or not context.owCanAttack.Value then return end

		local owAtkDebounce = context.playerDataFolder:FindFirstChild(playerData.owAtkDebounce.name)
		if not owAtkDebounce or owAtkDebounce.Value then return end

		owAtkDebounce.Value = true
		OoCModule.owAttack(context.player, context.classInfo, context.equippedWeapon, timeStart)

		-- Resetting debounce after animation length
		task.delay(animLength, function()
			if owAtkDebounce and owAtkDebounce.Parent then
				owAtkDebounce.Value = false
			end
		end)
	end)
end


return {
	regOwActionEventHandlers = regOwActionEventHandlers
}
