local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local remote1 = game.ReplicatedStorage.SFight
local remote2 = game.ReplicatedStorage.equipseq
local hitbox = game.ReplicatedStorage.Hitbox
local tool = script.Parent
local LoPlr = script.Parent.Parent.Parent
local cd = false
local cd2 = false

local function start()             --To summon box to initate fight 
	if cd == false then	
		cd = true
		local hitboxC = hitbox:Clone()
		local char = LoPlr.Character
		hitboxC.Parent = workspace
		hitboxC.CFrame = char.Torso.CFrame * CFrame.new(0,0,-5)
		local weld = Instance.new("WeldConstraint")
		weld.Parent = hitboxC
		weld.Part0 = hitboxC
		weld.Part1 = char.Torso
		
		local function touche(part)
			print(part.Name)
			if part.Name == "monsterhitbox" then
				remote1:FireServer()
			end
		end

		hitboxC.Touched:Connect(touche)
		
		wait(3)
		hitboxC:Destroy()
		cd = false
	end
end

local idleTrack

local function equip()
	if cd2 == false then
	cd = true
	cd2 = true
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local equipseq = game.ReplicatedStorage.equipseq
	remote2:FireServer(equipseq)


		local function Idle()
			local idleAnim = Instance.new("Animation")
			idleAnim.AnimationId = "rbxassetid://113314182099940"
			idleTrack = humanoid:LoadAnimation(idleAnim)
			idleTrack.Priority = Enum.AnimationPriority.Action
			idleTrack.Looped = true
			idleTrack:Play()
		end



	local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://92035534917618"
	local track = humanoid:LoadAnimation(anim)
	track:Play()
	track.Stopped:Connect(Idle)
		

	
	cd2 = false
	cd = false
	end
end



local function unequip()
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid and idleTrack and cd2 == false then
		cd2 = true
		idleTrack:Stop()
		idleTrack:Destroy()
		idleTrack = nil
		cd2 = false
	end
end

tool.Unequipped:Connect(unequip)
tool.Activated:Connect(start)
tool.Equipped:Connect(equip)

-- 113314182099940