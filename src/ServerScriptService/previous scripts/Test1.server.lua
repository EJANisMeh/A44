local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClassData = require(ReplicatedStorage.Data:WaitForChild("ClassData"))
local WeaponsFolder = ReplicatedStorage:WaitForChild("ClassWeapons")

local function weldWeaponToPlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local classValue = player:WaitForChild("Class")
	local className = classValue.Value
	local classInfo = ClassData[className]

	if classInfo and classInfo.WeaponName then
		local weaponModel = WeaponsFolder:FindFirstChild(classInfo.WeaponName)
		if weaponModel then
			local clone = weaponModel:Clone()
			local handle = clone.PrimaryPart
			if handle then
				clone.Parent = character

				local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
				if rightHand then
					local motor = Instance.new("Motor6D")
					motor.Part0 = rightHand
					motor.Part1 = handle
					motor.C0 = CFrame.new() -- adjust if needed
					motor.C1 = CFrame.new() -- adjust if needed
					motor.Name = "WeaponWeld"
					motor.Parent = rightHand
				end
			end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		weldWeaponToPlayer(player)
	end)
end)
