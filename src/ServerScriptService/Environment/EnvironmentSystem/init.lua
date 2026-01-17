local CollectionService = game:GetService("CollectionService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tagsData = require(ReplicatedStorage.Data:WaitForChild("TagsData"))
local mobsData = require(ReplicatedStorage.Data:WaitForChild("MobsData"))

local mobSpawner = require(script:WaitForChild("MobSpawner"))


local EnvironmentSystem = {}

function EnvironmentSystem:Init()
	self:InitMobs()
end

function EnvironmentSystem:InitMobs()
	for _, spawnPart in pairs(CollectionService:GetTagged(tagsData.MobSpawner)) do
		mobSpawner.spawnMob(spawnPart)
	end
end


return EnvironmentSystem
