-- (( Services ))--
local UserInputService = game: GetService("UserInputService") -- to detech user input--
local Players = game:GetService("Players") -- responsible for holding all the players in our game--

--(( Varaibles ))--
local player = Players.LocalPlayer -- for the indivdual player that joins the roblox game --
local tool = script.Parent -- tool instance that the thing is inside of

local animations = script.Parent.Animations 

-- (( Functions ))--
UserInputService.InputBegan:Connect(function(input, gameProcesseEvent) 
	
	-- input is the mousecllick or the touching of the screen
	-- game process event returns a boolean to check if the player is typing or not
	
	if gameProcesseEvent then return end
	if input.KeyCode == Enum.KeyCode.R then -- which key that activates the animation
		if player.Character:FindFirstChild(tool.Name) then
			local animationTrack = player.Character:FindFirstChild(("Humanoid").Animator:LoadAnimation(animations.StartBattle))
			animationTrack:Play()
		end
	end
end)

local idleAnimationTrack = player.Character:FindFirstChild(("humanoid").Animator:LoadAnimation(animations.Idle))

tool.Equipped:Connect(function()  --plays the animation when our player equips the tool
	idleAnimationTrack:Play()
end)

tool.Unequipped:Connect(function() --stops the animations when our player unequips
	idleAnimationTrack:stop()
end)
