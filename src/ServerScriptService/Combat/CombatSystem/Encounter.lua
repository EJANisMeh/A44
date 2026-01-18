local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local mobsData = require(ReplicatedStorage.Data:WaitForChild("MobsData"))
local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))

local EventDispatcher = require(ServerScriptService.EventDispatcher)

local function getNearbyMobs(mobHit)
	local mobsFolder = mobHit.Parent
	local nearbyMobs = {}
	for i, mob in pairs(mobsFolder:GetChildren()) do
		if mob ~= mobHit then
			local distance = (mob.PrimaryPart.Position - mobHit.PrimaryPart.Position).Magnitude
			if distance <= mobsData.DefaultValues.groupDistance then
				table.insert(nearbyMobs, mob)
			end
		end
	end
	return nearbyMobs
end


local encounter = {}

function encounter.StartEncounter(player, mob)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("PlayerData folder not found in", player); return end
	
	local playerIsInCombat = playerDataFolder:FindFirstChild(playerData.isInCombat.name)
	if not playerIsInCombat then warn("isInCombat is not found on", player); return end
	
	local playerOwCanAttack = playerDataFolder:FindFirstChild(playerData.owCanAttack.name)
	if not playerOwCanAttack then warn("owCanAttack value not found for", player); return end

	local mobValuesFolder = mob:FindFirstChild(mobsData.Values.valuesFolder.name)
	if not mobValuesFolder then warn("ValuesFolder not found in", mob); return end

	local mobName = mobValuesFolder:FindFirstChild(mobsData.Values.MobName.name)
	if not mobName then warn("MobName not found in", mob); return end
	
	local mobIsInCombat = mobValuesFolder:FindFirstChild(mobsData.Values.isInCombat.name)
	if not mobIsInCombat then warn("isInCombat not found in", mob); return end
	
	
	if mobIsInCombat.Value then return end
	

	-- start combat

	
	local nearbyMobs = getNearbyMobs(mob)
	
	-- remove nearby mobs already in battle and mark remaining nearby mobs as in-combat
	for i = #nearbyMobs, 1, -1 do
		local nearbyMob = nearbyMobs[i]

		local nearbyMobValuesFolder = nearbyMob:FindFirstChild(mobsData.Values.valuesFolder.name)
		if not nearbyMobValuesFolder then warn("ValuesFolder not found in", nearbyMob); return end

		local nearbyMobIsInCombat = nearbyMobValuesFolder:FindFirstChild(mobsData.Values.isInCombat.name)
		if not nearbyMobIsInCombat then warn("isInCombat not found in", nearbyMob); return end

		if nearbyMobIsInCombat.Value then
			table.remove(nearbyMobs, i)
		else
			nearbyMobIsInCombat.Value = true
		end
	end
	
	
	if script.EncounterTest.Value then
		print("Encounter started by", player.Name, "against", mob.Name)
		print("Mob stats:", mobsData[mobName.Value])
	end

	if script.EncounterTest.Value and #nearbyMobs ~= 0 then
		print("Nearby mobs within", mobsData.DefaultValues.groupDistance, "studs:", nearbyMobs)
	end

	mobIsInCombat.Value = true
	
	local mobsToCombat = {mob, nearbyMobs}
	
	playerIsInCombat.Value = true
	playerOwCanAttack.Value = false
	
	-- encountercombat fire to server
	local context = {
		combatType = eventsData.CombatStart.Encounter,
		player = player,
		targets = mobsToCombat,
	}
	
	EventDispatcher:Dispatch(eventsData.CombatStart, context)
end
	
return encounter
