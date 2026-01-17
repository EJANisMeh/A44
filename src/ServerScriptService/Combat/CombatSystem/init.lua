local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventDispatcher = require(ServerScriptService.EventDispatcher)

local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))
local classData 	= require(ReplicatedStorage.Data:WaitForChild("ClassData"))
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local classManager 	= require(ReplicatedStorage.Modules:WaitForChild("ClassManager"))

local InCombatModule = require(script:WaitForChild("In-Combat"))
local CombatEventHandlers = require(script:WaitForChild("InitCombatEventHandlers"))

local ActionEvent = ReplicatedStorage.Events:WaitForChild("InputAction")



local CombatSystem = {}

function CombatSystem:Init()
	CombatEventHandlers.regCombatEventHandlers()
	InCombatModule:RegisterDispatcherEvents()
	
	self:InitActionEvent()
	
	EventDispatcher:Register(eventsData.CombatStart, function(context)
		InCombatModule:InitCombat(context)

		InCombatModule:EnableCombatGui(context.player, context.targets)
	end)
	
end


function CombatSystem:InitActionEvent()
	ActionEvent.OnServerEvent:Connect(function(player, action, ...)
		local context = {
			player = player
		}

		context.playerDataFolder = player:FindFirstChild(playerData.FolderName)
		if not context.playerDataFolder then warn("PlayerData folder not found on", player.Name) return end

		context.classInfo = classManager.getPlayerClassInfo(player)
		if not context.classInfo then warn("Class info not found for", player.Name) return end

		context.isLoaded = context.playerDataFolder:FindFirstChild(playerData.isLoaded.name)
		if not context.isLoaded then warn("Cannot find isLoaded on", player.Name) return end

		context.isInCombat = context.playerDataFolder:FindFirstChild(playerData.isInCombat.name)
		if not context.isInCombat then warn("Cannot find isInCombat on", player.Name) return end

		context.equippedWeapon = context.playerDataFolder:FindFirstChild(playerData.equippedWeapon.name)
		if not context.equippedWeapon then warn("Cannot find equippedWeapon on", player.Name) return end

		context.owCanAttack = context.playerDataFolder:FindFirstChild(playerData.owCanAttack.name)
		if not context.equippedWeapon then warn("Cannot find owCanAttack on", player.Name) return end

		EventDispatcher:Dispatch(action, context, ...)
	end)
end

return CombatSystem