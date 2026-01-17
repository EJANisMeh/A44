local remote = game.ReplicatedStorage.equipseq

local function equip1(player)
	local char = player.Character
	local scythe = char.Start
	local attachPart = scythe.BAttach
	local arm = char:FindFirstChild("Right Arm")

	local motor = Instance.new("Motor6D")
	motor.Name = "ScytheWeld"
	motor.Part0 = arm
	motor.Part1 = attachPart
	motor.C0 = CFrame.new(0, 0, 0)
	motor.Parent = arm
	
	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxassetid://243660364"
	particles.Rate = 1000
	particles.Lifetime = NumberRange.new(0.5)
	particles.Speed = NumberRange.new(5)
	particles.SpreadAngle = Vector2.new(360, 360)
	particles.Size = NumberSequence.new(4)
	particles.Transparency = NumberSequence.new(0)
	particles.Parent = attachPart.MeshPart


	game.Debris:AddItem(particles, 0.5)
	
end

remote.OnServerEvent:Connect(equip1)