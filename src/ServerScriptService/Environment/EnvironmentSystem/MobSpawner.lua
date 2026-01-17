local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tagsData = require(ReplicatedStorage.Data:WaitForChild("TagsData"))
local mobsData = require(ReplicatedStorage.Data:WaitForChild("MobsData"))


local mobSpawner = {}

function mobSpawner.spawnMob(spawnPart)
	local mobObj = spawnPart:FindFirstChild("Mob")
	local cooldown = spawnPart:FindFirstChild("Cooldown")
	local lingerTime = spawnPart:FindFirstChild("LingerTime")
	local amount = spawnPart:FindFirstChild("Amount")
	local spawnedMobs = spawnPart:FindFirstChild("SpawnedMobs")

	if not mobObj or not mobObj.Value then
		warn("Mob object value missing in spawner:", spawnPart)
		return
	end

	if not cooldown then
		warn("Cooldown value missing in spawner:", spawnPart)
		return
	end

	if not lingerTime then
		warn("LingerTime value missing in spawner:", spawnPart)
		return
	end

	if not amount then
		warn("Mob amount value missing in spawner:", spawnPart)
		return
	end

	if not spawnedMobs then
		warn("SpawnedMobs folder missing in spawner:", spawnPart)
		return
	end

	local mobCount = #spawnedMobs:GetChildren()


	if not (mobCount < amount.Value) then return end

	for i = 1, amount.Value - mobCount do
		local mobClone = mobObj.Value:Clone()
		mobClone:SetPrimaryPartCFrame(getRandomPos(spawnPart))
		
		initMobValues(mobClone)

		CollectionService:AddTag(mobClone, tagsData.MobEncounter)
		-- [[test
		if script.MobSpawnerTest.Value then
			mobClone.Name = mobClone.Name .. i
		end
		-- ]]test
		mobClone.Parent = spawnedMobs
	end
end

function getRandomPos(spawnPart)
	local size = spawnPart.Size
	local cframe = spawnPart.CFrame

	local x = (math.random() - 0.5) * size.X
	local z = (math.random() - 0.5) * size.Z

	local topPosition = cframe * Vector3.new(x, size.Y/2, z)
	local bottomPosition = cframe * Vector3.new(x, -size.Y/2, z)
	local studsOffsetY = 5

	local rayOrigin = topPosition + Vector3.new(0, studsOffsetY, 0)
	local rayDirection = Vector3.new(0, -100, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {spawnPart}

	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

	if raycastResult then
		return CFrame.new(raycastResult.Position)
	else
		return bottomPosition
	end
end

function initMobValues(mob)
	local valuesFolder = Instance.new("Folder")
	valuesFolder.Name = mobsData.Values.valuesFolder.name
	valuesFolder.Parent = mob

	local mobName = Instance.new("StringValue")
	mobName.Name = mobsData.Values.MobName.name
	mobName.Value = mob.Name
	mobName.Parent = valuesFolder

	local isInCombat = Instance.new("BoolValue")
	isInCombat.Name = mobsData.Values.isInCombat.name
	isInCombat.Value = mobsData.Values.isInCombat.value
	isInCombat.Parent = valuesFolder
end


return mobSpawner
