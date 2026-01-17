local Players				= game:GetService("Players")
local DataStoreService 		= game:GetService("DataStoreService")
local ReplicatedStorage		= game:GetService("ReplicatedStorage")
local ServerScriptService	= game:GetService("ServerScriptService")

local playerDataModule 	= require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("PlayerData"))
local dbModule 			= require(ServerScriptService:WaitForChild("Database"):WaitForChild(("Database")))

local playerDataKey 	= tostring(DataStoreService:GetDataStore(playerDataModule["DataKey"]))

local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))


Players.PlayerAdded:Connect(function(player)
	dbModule.initPlayerData(player, playerDataModule)
	dbModule.loadPlayerData(player, playerDataKey)
end)

Players.PlayerRemoving:Connect(function(player)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	local sSlot = playerDataFolder:FindFirstChild(playerData.SaveSlot.name)
	
	local valuesToSave = {}
	local class = playerDataFolder:FindFirstChild(playerData.Class.name)
	
	valuesToSave[#valuesToSave+1] = class
	
	
	--[ test [[
	if sSlot.Value == 1 then
		class.Value = "Scythe"
	elseif sSlot.Value == 2 then
		class.Value = "Monk"
	end
	-- ]]--
	
	dbModule.savePlayerData(player, playerDataKey, valuesToSave)
end)