local inputModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerData = require(ReplicatedStorage.Data:WaitForChild("PlayerData"))
local eventsData = require(ReplicatedStorage.Data:WaitForChild("EventsData"))
local ActionEvent = ReplicatedStorage.Events:WaitForChild("InputAction")
local ShapecastHitbox = require(ReplicatedStorage.Modules.ShapecastHitbox)

local animationCache = {}


function inputModule.handleActivationBegan(player, ...)
	local playerDataFolder = player:FindFirstChild(playerData.FolderName)
	if not playerDataFolder then return end

	local isInCombat = playerDataFolder:FindFirstChild(playerData.isInCombat.name)
	if not isInCombat then return end

	local equippedWeapon = playerDataFolder:FindFirstChild(playerData.equippedWeapon.name)
	if not equippedWeapon then return end


	if not isInCombat.Value then
		if not equippedWeapon.Value then return end -- modify in the future if there is a class weapon data
		local classInfo = ...
		owAttackInput(player, classInfo)
	end
end

local attackDebounce = false

function owAttackInput(player, classInfo)
	if not attackDebounce then
		attackDebounce = true

		local playerDataFolder = player:FindFirstChild(playerData.FolderName)
		if not playerDataFolder then 
			attackDebounce = false
			return 
		end

		local weapon = playerDataFolder.equippedWeapon.Value
		if not weapon then 
			attackDebounce = false
			return 
		end

		local weaponModel = weapon:FindFirstChild(classInfo.WeaponName)
		if not weaponModel then 
			attackDebounce = false
			return 
		end

		local hitboxPart = weaponModel:FindFirstChild("Hitbox")
		if not hitboxPart then 
			attackDebounce = false
			return 
		end

		--local newHitbox = ShapecastHitbox.new(hitboxPart)

		local timeStart

		-- load attack animation and play		
		local attackAnim = loadOwAttackAnim(player, classInfo)

		local playAttackAnim = coroutine.create(function()
			timeStart = os.clock()
			attackAnim:Play()
		end)
		coroutine.resume(playAttackAnim)

		ActionEvent:FireServer(eventsData.InputActions.owAttack, timeStart, attackAnim.Length)

		-- wait until animation is finished
		repeat task.wait() until os.clock() - timeStart > attackAnim.Length + classInfo.OwAtkCooldown

		attackDebounce = false
	end
end

function loadOwAttackAnim(player, classInfo)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local M1AnimId = classInfo.M1Animation
	if not M1AnimId then warn("No animation id found") return end

	local M1Animation = animationCache[M1AnimId]
	if not M1Animation then
		M1Animation = Instance.new("Animation")
		M1Animation.AnimationId = M1AnimId
		animationCache[M1AnimId] = M1Animation
	end

	local M1AnimTrack = humanoid:LoadAnimation(M1Animation)
	repeat task.wait() until M1AnimTrack.Length > 0
	M1AnimTrack.Priority = Enum.AnimationPriority.Action
	M1AnimTrack.Looped = false
	return M1AnimTrack
end


local sheateDebounce = false
function inputModule.handleSheating(player, classInfo)
	if not sheateDebounce then
		sheateDebounce = true

		ActionEvent:FireServer(eventsData.InputActions.Sheate)
		task.wait(classInfo.SheateCooldown)

		sheateDebounce = false
	end
end

return inputModule


