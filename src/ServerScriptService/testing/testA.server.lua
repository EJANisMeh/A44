local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local tagsData = require(ReplicatedStorage.Data:WaitForChild("TagsData"))

-- Function to get random position within a part
local function getRandomPositionInPart(spawnerPart)
	local size = spawnerPart.Size
	local cframe = spawnerPart.CFrame

	-- Get random X and Z positions within the part
	local x = (math.random() - 0.5) * size.X
	local z = (math.random() - 0.5) * size.Z

	-- Calculate position at top of spawner area
	local topPosition = cframe * Vector3.new(x, size.Y/2, z)

	-- Raycast downward to find ground
	local rayOrigin = topPosition + Vector3.new(0, 5, 0)  -- Start 5 studs above top
	local rayDirection = Vector3.new(0, -100, 0)  -- Cast 100 studs down
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {spawnerPart}

	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

	if raycastResult then
		-- Found ground - use hit position
		return CFrame.new(raycastResult.Position)
	else
		-- Fallback: Use bottom of spawner area
		return cframe * Vector3.new(x, -size.Y/2, z)
	end
end

-- Function to spawn a mob
local function spawnMob(spawner)
	local mobValue = spawner:FindFirstChild("Mob")
	local cooldown = spawner:FindFirstChild("Cooldown")
	local amount = spawner:FindFirstChild("Amount")

	if not mobValue or not mobValue.Value then
		warn("Mob object value missing in spawner: " .. spawner.Name)
		return
	end

	if not cooldown then
		warn("Cooldown value missing in spawner: " .. spawner.Name)
		return
	end

	if not amount then
		warn("Amount value missing in spawner: " .. spawner.Name)
		return
	end

	-- Get current mob count for this spawner
	local mobCount = #CollectionService:GetTagged(spawner.Name .. "_Mob")

	-- Spawn if below max amount
	if mobCount < amount.Value then
		local mobModel = mobValue.Value:Clone()

		-- Position mob randomly within the spawner part
		mobModel:SetPrimaryPartCFrame(getRandomPositionInPart(spawner))

		-- Tag mob for tracking
		CollectionService:AddTag(mobModel, spawner.Name .. "_Mob")

		-- Store spawner reference
		if not mobModel:FindFirstChild("Spawner") then
			local spawnerRef = Instance.new("ObjectValue")
			spawnerRef.Name = "Spawner"
			spawnerRef.Value = spawner
			spawnerRef.Parent = mobModel
		end

		mobModel.Parent = workspace

		-- Clean up when mob dies
		local humanoid = mobModel:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				task.wait(5)  -- Body linger time
				if mobModel and mobModel.Parent then
					mobModel:Destroy()
				end
			end)
		else
			warn("Mob model missing Humanoid: " .. mobModel.Name)
		end
	end
end

-- Initialize spawners
for _, spawner in ipairs(CollectionService:GetTagged(tagsData.MobSpawner)) do
	-- Start spawn loop for each spawner
	task.spawn(function()
		while true do
			spawnMob(spawner)
			local cooldown = spawner:FindFirstChild("Cooldown")
			local delayTime = cooldown and cooldown.Value or 30
			task.wait(delayTime)
		end
	end)
end

-- Optional: Handle spawner cleanup when it's removed
CollectionService:GetInstanceAddedSignal(tagsData.MobSpawner):Connect(function(spawner)
	task.spawn(function()
		while true do
			if not spawner or not spawner.Parent then break end
			spawnMob(spawner)
			local cooldown = spawner:FindFirstChild("Cooldown")
			task.wait(cooldown and cooldown.Value or 30)
		end
	end)
end)

CollectionService:GetInstanceRemovedSignal(tagsData.MobSpawner):Connect(function(spawner)
	-- Clean up all mobs from this spawner
	for _, mob in ipairs(CollectionService:GetTagged(spawner.Name .. "_Mob")) do
		mob:Destroy()
	end
end)