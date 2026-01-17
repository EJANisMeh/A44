
game.Players.PlayerAdded:Connect(function(player) -- runs the functionw when the player joins the game
	player.CharacterAdded:Connect(function(character) --character and player is diff Chracter is the player avatar/3D model player is what you see inside the player service the backpack and anyvalues are stored
		wait(1)
		local arm = character:FindFirstChild("Right Arm") -- changed to FindFirstChild because the name "Right Arm" has a space
		local motor6d = Instance.new("Motor6D")	
		print(arm)	
		motor6d.Name = "ToolAttach"
		motor6d.Parent = arm --based on which part you welded the thingy to

		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") and child:FindFirstChild("BAttach") then -- BAttach is the name of ur part
				motor6d.Part1 = child.BAttach
				motor6d.Part0 = arm
			end
		end)
	end)
end)