-- ServerScriptService.ClassManager

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ClassDataStore = DataStoreService:GetDataStore("PlayerClassData") -- can name anything

-- Helper function to give class StringValue to player
local function addClassValue(player, className)
	local classValue = Instance.new("StringValue")
	classValue.Name = "Class"
	classValue.Value = className or "Scythe" -- testing class because im stupid
	classValue.Parent = player
end

-- Load player's class from datastore
Players.PlayerAdded:Connect(function(player)
	local success, savedClass = pcall(function()
		return ClassDataStore:GetAsync(player.UserId)
	end)

	if success and savedClass then
		addClassValue(player, savedClass)
	else
		addClassValue(player) -- default if no saved data
	end
end)

-- Save on leave
Players.PlayerRemoving:Connect(function(player)
	local class = player:FindFirstChild("Class")
	if class then
		pcall(function()
			ClassDataStore:SetAsync(player.UserId, class.Value)
		end)
	end
end)
