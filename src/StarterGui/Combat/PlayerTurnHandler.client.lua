local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))

local CombatActionEvent = ReplicatedStorage.Events:WaitForChild("CombatAction")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = playerGui:WaitForChild("Combat")
local mainFrame = screenGui:WaitForChild("Main")
local movesFrame = screenGui:WaitForChild("Moves")
local itemsFrame = screenGui:WaitForChild("Items")

-- Buttons
local fightBtn = mainFrame:WaitForChild("FightButton")
local guardBtn = mainFrame:WaitForChild("GuardButton")
local itemBtn = mainFrame:WaitForChild("ItemButton")
local escapeBtn = mainFrame:WaitForChild("EscapeButton")

local movesBackBtn = movesFrame:WaitForChild("BackButton")
local itemsBackBtn = itemsFrame:WaitForChild("BackButton")

local activeFrame = mainFrame

local conns = {}

-- Simulated function calls for actions
local function onFight()
	print("You chose to Fight!")
	-- Trigger damage animation, attack logic, or send event to server
	mainFrame.Visible = false
	activeFrame = movesFrame
	movesFrame.Visible = true
end

local function onGuard()
	print("You chose to Guard!")
	-- Set guard state, reduce damage taken, etc.
end

local function onItem()
	print("You chose to use an Item!")
	-- Open inventory UI or auto-use selected item
	mainFrame.Visible = false
	activeFrame = itemsFrame
	itemsFrame.Visible = true
end

local function onEscape()
	print("You chose to Escape!")
	-- Attempt escape logic, success chance, etc.
	-- disconnect connections
	CombatActionEvent:FireServer(eventsData.CombatActions.Escape)
end

local function onBack()
	if activeFrame == movesFrame then
		movesFrame.Visible = false
		activeFrame = mainFrame
		mainFrame.Visible = true
	end
	if activeFrame == itemsFrame then
		itemsFrame.Visible = false
		activeFrame = mainFrame
		mainFrame.Visible = true
	end
end

local function onMoveClick(button)
	local conn = button.MouseButton1Click:Connect(function()
		CombatActionEvent:FireServer(eventsData.CombatActions.Fight, button)
	end)
	table.insert(conns, conn)
end

local function initButtonFunctions(buttons)
	for _, button in pairs(buttons) do
		onMoveClick(button)
	end
end

local function disconnectConnections()
	for _, conn in pairs(conns) do
		conn:Disconnect()
	end
	
	conns = {}
end

-- Connect buttons to actions
fightBtn.MouseButton1Click:Connect(onFight)

guardBtn.MouseButton1Click:Connect(onGuard)

itemBtn.MouseButton1Click:Connect(onItem)

escapeBtn.MouseButton1Click:Connect(onEscape)

movesBackBtn.MouseButton1Click:Connect(onBack)

itemsBackBtn.MouseButton1Click:Connect(onBack)

CombatActionEvent.OnClientEvent:Connect(function(action, ...)
	if action == eventsData.GUI.InitMoveButtons then
		local buttons = ...
		initButtonFunctions(buttons)
		return
	end
	
	if action == eventsData.CombatActions.Escape then
		disconnectConnections()
	end
end)