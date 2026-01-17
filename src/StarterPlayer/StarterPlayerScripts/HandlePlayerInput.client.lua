local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local inputModule = require(script.Parent.Modules:WaitForChild("Input"))
local classManager = require(game.ReplicatedStorage.Modules:WaitForChild("ClassManager"))
local classData = require(game.ReplicatedStorage.Data:WaitForChild("ClassData"))
local playerData = require(game.ReplicatedStorage.Data:WaitForChild("PlayerData"))

local player = Players.LocalPlayer

local activateInputs = {
	MouseButton1 = true,
	Touch = true,
	-- add more for other platform compatibility
}

local sheateInputs = {
	F = true,
}


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then return end
	
	local isLoaded = playerDataFolder:FindFirstChild(playerData.isLoaded.name)
	if not isLoaded then return end
	
	if not isLoaded.Value then return end
	
	if activateInputs[input.KeyCode.Name] or activateInputs[input.UserInputType.Name] then
		local classInfo = classManager.getPlayerClassInfo(player)
		if not classInfo then warn("Class Info value not found") return end
		inputModule.handleActivationBegan(player, classInfo)
	end
	
	if sheateInputs[input.KeyCode.Name] or sheateInputs[input.UserInputType.Name] then
		local classInfo = classManager.getPlayerClassInfo(player)
		if not classInfo then warn("Class Info value not found") return end
		inputModule.handleSheating(player, classInfo)
	end
end)