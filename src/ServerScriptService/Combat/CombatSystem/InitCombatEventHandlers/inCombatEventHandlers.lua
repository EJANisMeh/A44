local ServerScriptService = game:GetService("ServerScriptService")
local EventDispatcher = require(ServerScriptService:WaitForChild("EventDispatcher"))
local CombatSystemModule = ServerScriptService.Combat:WaitForChild("CombatSystem")
local InCombatSystem =  require(CombatSystemModule:WaitForChild("In-Combat"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))
local CombatActionEvent = ReplicatedStorage.Events:WaitForChild("CombatAction")


function regInCombatEventHandlers()
	EventDispatcher:Register(eventsData.CombatActions.Fight, function(context, button)
		print("Clicked:", button)
	end)
	
	EventDispatcher:Register(eventsData.CombatActions.Escape, function(context, button)
		local player = context.player
		local playerId = tostring(context.player.UserId)
		
		CombatActionEvent:FireClient(player, eventsData.CombatActions.Escape)
		EventDispatcher:Dispatch(eventsData.Connections.DisconnectInCombatConnections, tostring(playerId))
		
		InCombatSystem:DisableCombatGui(player)
		InCombatSystem:EndCombat(player)
		
		if script.inCombatEventHandlersTest.Value then
			print("Successfully escaped")
		end
	end)
end

return {
	regInCombatEventHandlers = regInCombatEventHandlers
}
