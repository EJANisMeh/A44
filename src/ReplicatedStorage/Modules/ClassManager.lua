local ReplicatedStorage = game:GetService("ReplicatedStorage")

local classData 	= require(ReplicatedStorage.Data:WaitForChild("ClassData"))
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))


local classManager = {}

function classManager.getPlayerClassInfo(player)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then return end

	local classValue = playerDataFolder:FindFirstChild(playerData.Class.name)
	if not classValue then warn("Class value not found") return end

	local playerClass = classValue.Value

	local classInfo = classData[playerClass]
	if not classInfo then 
		return nil
	end

	return classInfo
end


return classManager
