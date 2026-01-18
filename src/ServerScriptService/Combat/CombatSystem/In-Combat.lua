local ServerStorage = game:GetService("ServerStorage")
local ScrollingFrameTemplate = ServerStorage.GuiTemplate:WaitForChild("CombatScrollingFrame")

local ServerScriptService = game:GetService("ServerScriptService")
local EventDispatcher = require(ServerScriptService:WaitForChild("EventDispatcher"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local movesData = require(ReplicatedStorage.Data:WaitForChild("MovesData"))
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))
local mobsData = require(ReplicatedStorage.Data:WaitForChild("MobsData"))
local CombatActionEvent = ReplicatedStorage.Events:WaitForChild("CombatAction")

local conns = {}

local battleArenas = {}
-- to implement: when combat ends, mobs isincombat value is set to true

local IC = {}

local function onCombatActionActivated(player, action, ...) -- when player clicks a move button
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder missing for", player); return end
	
	local isCurrentTurn = playerDataFolder:FindFirstChild(playerData.isCurrentTurn.name)
	if not isCurrentTurn then warn("isCurrentTurn value missing for", player); return end
	
	--if not isCurrentTurn.Value then return end
	
	local context = {
		player = player
	}
	
	EventDispatcher:Dispatch(action, context, ...)
end

function IC:InitCombat(context)
	local playerId = tostring(context.player.UserId)
	
	battleArenas[playerId] = {
		opponents = context.targets,
	}
	
	if script["In-CombatTest"].Value then
		print("Conns:", conns)
		print("BattleArenas:", battleArenas)
	end
	
	local conn = CombatActionEvent.OnServerEvent:Connect(onCombatActionActivated)
	conns[playerId] = {}
	
	table.insert(conns[playerId], conn)
	
	if script["In-CombatTest"].Value then
		print("Conns:", conns)
	end
end

function IC:RegisterDispatcherEvents()
	EventDispatcher:Register(eventsData.Connections.DisconnectInCombatConnections, cleanupConnections)
end

function IC:EnableCombatGui(player, targets)
	local playergui = player:FindFirstChildWhichIsA("PlayerGui")
	local combatgui = playergui:FindFirstChild("Combat")
	
	initButtons(player)
	combatgui.Enabled = true
end

function IC:DisableCombatGui(player)
	local playergui = player:FindFirstChildWhichIsA("PlayerGui")
	local combatgui = playergui:FindFirstChild("Combat")

	combatgui.Enabled = false
	cleanupButtons(player)
end

function IC:EndCombat(player)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder missing for", player); return end

	local isInCombat = playerDataFolder:FindFirstChild(playerData.isInCombat.name)
	if not isInCombat then warn("isInCombat value not found for", player); return end

	local owCanAttack = playerDataFolder:FindFirstChild(playerData.owCanAttack.name)
	if not owCanAttack then warn("owCanAttack value not found for", player); return end
	
	local playerId = tostring(player.UserId)
	
	local opponents = unpackOpponentsTable(battleArenas[playerId]["opponents"])
	
	for _, opponent in ipairs(opponents) do
		local valuesFolder = opponent:FindFirstChild(mobsData.Values.valuesFolder.name)
		
		local opponentIsInCombat = valuesFolder:FindFirstChild(mobsData.Values.isInCombat.name)
		
		opponentIsInCombat.Value = false
	end
	
	if script["In-CombatTest"].Value then
		print(battleArenas)
	end
	
	battleArenas[playerId] = nil
	
	if script["In-CombatTest"].Value then
		print(battleArenas)
	end
	
	isInCombat.Value = false
	owCanAttack.Value = true
end



function initButtons(player)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	local playerClass = playerDataFolder:FindFirstChild(playerData.Class.name)
	local playerClassMoves = movesData.ClassMoves[playerClass.Value]

	local playergui = player:FindFirstChildWhichIsA("PlayerGui")
	local combatgui = playergui:FindFirstChild("Combat")
	local movesFrame = combatgui:FindFirstChild("Moves")
	local movesScrollFrame = movesFrame:FindFirstChildWhichIsA("ScrollingFrame")
	
	-- initiating move buttons
	local moveButtons = {}

	for i, values in ipairs(playerClassMoves) do
		local moveButton = ScrollingFrameTemplate:WaitForChild("TextButton"):Clone()
		moveButton.Name = i
		moveButton.Text = values.name
		moveButton.Parent = movesScrollFrame

		table.insert(moveButtons, moveButton)
	end

	CombatActionEvent:FireClient(player, eventsData.GUI.InitMoveButtons, moveButtons)
	
	-- initiating item buttons (not done)
	--local items = {}
	
end

function cleanupButtons(player)
   -- unused for now
	-- local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	-- local playerClass = playerDataFolder:FindFirstChild(playerData.Class.name)
	-- local playerClassMoves = movesData.ClassMoves[playerClass.Value]

	local playergui = player:FindFirstChildWhichIsA("PlayerGui")
	local combatgui = playergui:FindFirstChild("Combat")
	local movesFrame = combatgui:FindFirstChild("Moves")
	local movesScrollFrame = movesFrame:FindFirstChildWhichIsA("ScrollingFrame")
	local itemsFrame = combatgui:FindFirstChild("Items")
	local itemsScrollFrame = itemsFrame:FindFirstChildWhichIsA("ScrollingFrame")
	
	destroyTextButtons(movesScrollFrame)
	destroyTextButtons(itemsScrollFrame)
end

function destroyTextButtons(parent)
	for i, v in pairs(parent:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

function unpackOpponentsTable(opponents)
	local opponentsTable
	
	if opponents[2] then
		opponentsTable = {opponents[1], table.unpack(opponents[2])}
	else
		opponentsTable = {opponents[1]}
	end
	
	return opponentsTable
end

function cleanupConnections(playerId)
	if script["In-CombatTest"].Value then
		print(playerId)
	end
	if conns[playerId] then
		-- Disconnect all connections for this player
		for _, conn in ipairs(conns[playerId]) do
			conn:Disconnect()

			if script["In-CombatTest"].Value then
				print("connection disconnected")
			end
		end

		-- Remove the player's connection table
		conns[playerId] = nil
		
		if script["In-CombatTest"].Value then
			print("Conns:", conns)
		end
	end
end
	
return IC
