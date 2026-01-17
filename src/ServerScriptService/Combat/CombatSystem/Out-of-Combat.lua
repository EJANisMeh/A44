local OoC = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")

local ShapecastHitbox = require(ReplicatedStorage.Modules:WaitForChild("ShapecastHitbox"))
local tagsData = require(ReplicatedStorage.Data:WaitForChild("TagsData"))

local CombatSystem = script.Parent
local EncounterModule = require(CombatSystem:WaitForChild("Encounter"))

local WeaponsFolder = ReplicatedStorage:WaitForChild("ClassWeapons")
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))



function OoC.unsheateWeapon(player, classInfo)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder not found") return end

	local equippedWeapon = playerDataFolder:FindFirstChild(playerData.equippedWeapon.name)
	if not equippedWeapon then warn("equippedWeapon value not found") return end
	
	local weapon = initWeapon(player, classInfo)
	
	equippedWeapon.Value = weapon
end

function OoC.sheateWeapon(player)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then return end

	local equippedWeapon = playerDataFolder:FindFirstChild(playerData.equippedWeapon.name)
	if not equippedWeapon then return end

	equippedWeapon.Value:Destroy()

	equippedWeapon.Value = nil
end

function OoC.owAttack(player, classInfo, equippedWeapon, timeStart)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then warn("Player data folder not found") return end
	
	if not equippedWeapon.Value then return end
	
	local hitboxPart = equippedWeapon.Value:FindFirstChildWhichIsA("Part"):FindFirstChild("Hitbox")
	if not hitboxPart then 
		warn("Hitbox not found " .. classInfo.WeaponName) 
		return 
	end
	
	local newHitbox = ShapecastHitbox.new(hitboxPart)
	local hitboxColorTemp = hitboxPart.Color
	
	repeat task.wait() until os.clock() - timeStart > classInfo.owAtkAnimDmgStart
	
	initWeaponHitbox(player, newHitbox, hitboxPart)
	
	repeat task.wait() until os.clock() - timeStart > classInfo.owAtkAnimDmgEnd
	
	hitboxPart.Color = hitboxColorTemp
	newHitbox:HitStop()
end


function attachWeapon(weapon, hand)
	local handle = weapon.PrimaryPart
	if not handle then warn("Weapon handle not found") return end

	local motor = hand:FindFirstChild("WeaponWeld")
	if not motor then
		motor = Instance.new("Motor6D")
		motor.Part0 = hand
		motor.C0 = CFrame.new() -- adjust if needed
		motor.C1 = CFrame.new() -- adjust if needed
		motor.Name = "WeaponWeld"
		motor.Parent = hand
	end

	motor.Part1 = handle
end

function initWeapon(player, classInfo) -- not finished
	local weaponToEquip = WeaponsFolder:FindFirstChild(classInfo.WeaponName)
	if not weaponToEquip then warn("Weapon model not found for: " .. classInfo.WeaponName) return end


	local character = player.Character or player.CharacterAdded:Wait()

	local weaponToEquip = weaponToEquip:Clone()
	weaponToEquip.Parent = character


	if classInfo["WeaponHeld"] == "Left" then
		print("Left hand weapon attach test")
	elseif classInfo["WeaponHeld"] == "Right" then
		local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
		if not rightHand then weaponToEquip:Destroy() return end

		attachWeapon(weaponToEquip, rightHand)
	elseif classInfo["WeaponHeld"] == "Both" then
		print("2 handed weapon attach test")
	end

	return weaponToEquip
end

function initWeaponHitbox(player, newHitbox, hitboxPart)
	local hitDebounce = false
	newHitbox:HitStart(3):OnHit(function(raycastResult, segmentHit)
		if raycastResult and not hitDebounce then
			hitDebounce = true
			local hit = raycastResult.Instance.Parent
			local character = player.Character or player.CharacterAdded:Wait()
			local myHumanoid = character:FindFirstChildWhichIsA("Humanoid")
			local humanoidHit = hit:FindFirstChildWhichIsA("Humanoid")

			if humanoidHit and humanoidHit ~= myHumanoid then
				if CollectionService:HasTag(hit, tagsData.MobEncounter) then 
					EncounterModule.StartEncounter(player, hit)
					hitboxPart.Color = Color3.new(170, 0, 170)
					newHitbox:HitStop()
				end
			else
				hitDebounce = false
			end
		end
	end):OnStopped(function(cleanCallbacks)
		cleanCallbacks()
		newHitbox:Destroy()
	end)
end

return OoC
