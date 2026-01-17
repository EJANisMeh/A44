--[[ Future implementations:
backup system
update functionality when we have start menu
]]-- 

local dbModule = {}

local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))


function dbModule.loadPlayerData(player, dataKey)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder missing") return end
	
	local sSlot = playerDataFolder:FindFirstChild(playerData.SaveSlot.name)
	if not sSlot then warn("Can't find save slot") return end
	sSlot = sSlot.Value
	
	local playerData = dbModule.getPlayerData(player, dataKey)
	if not playerData then return end
	if not playerData[sSlot] then warn("Can't find player data save slot") return end
	
	local playerDataSlot = playerData[sSlot]
	
	for key, value in pairs(playerDataSlot) do
		local instance = playerDataFolder:FindFirstChild(key)
		if instance then
			instance.Value = value
		end
	end
	
	print(player.Name .. "'s loaded player data:", playerDataSlot)
end

function dbModule.savePlayerData(player, dataKey, values)
	local playerDataStore = DataStoreService:GetDataStore(dataKey)
	local playerKey = tostring(player.UserId)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder missing") end
	
	local sSlot = playerDataFolder:FindFirstChild(playerData.SaveSlot.name)
	if not sSlot then warn("Can't find save slot") return end
	sSlot = sSlot.Value
		
	if #values == 0 then
		warn("No values to save.")
		return
	end
	
	local playerData = dbModule.getPlayerData(player, dataKey)
	if not playerData then
		playerData = {}
	end
	
	local dataToSave = {}
	
	for _, value in pairs(values) do
		-- print("Saving value:", value.Name, "=", value.Value)
		dataToSave[value.Name] = value.Value
	end

	local newPlayerData = playerData
	newPlayerData[sSlot] = dataToSave

	local success, err = pcall(function()
		playerDataStore:SetAsync(playerKey, newPlayerData)
		print(player.Name .. "'s saved player data:", playerData)
	end)

	if not success then
		warn("Data save failed for " .. player.Name .. ":", err)
	end
end

function dbModule.getPlayerData(player, dataKey)
	local playerDataStore = DataStoreService:GetDataStore(dataKey)
	local playerKey = tostring(player.UserId)
	
	local success, playerData = pcall(function()
		return playerDataStore:GetAsync(playerKey)
	end)

	if success then
		return playerData
	else
		warn("Failed to load player data: " .. player.Name)
		return nil
	end
end

function dbModule.initPlayerData(player, playerDataModule)
	local playerDataFolder = Instance.new("Folder")
	playerDataFolder.Name = playerData.FolderName
	playerDataFolder.Parent = player

	for key, dataTable in pairs(playerDataModule) do
		if type(dataTable) == "table" and dataTable.instance then
			local instance = Instance.new(dataTable.instance)
			instance.Parent = playerDataFolder
			instance.Name = dataTable.name
			instance.Value = dataTable.value
		end
	end
end

return dbModule