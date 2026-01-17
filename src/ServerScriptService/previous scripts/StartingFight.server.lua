local remote1 = game.ReplicatedStorage:WaitForChild("SFight")
local cd = false

local function hit(player, part)
	print("Server event triggered")
	if cd then
		print("Server on cooldown")
		return
	end

	if part and part.Name == "monsterhitbox" then
		cd = true
		print("Hit registered!")
		print("Hit part name:", part.Name)
		print("Hit monster model:", part.Parent.Name)
		print("Player who hit:", player.Name)
		wait(1)
		cd = false
	end
end

remote1.OnServerEvent:Connect(hit)

-- this is how we will start the fight, since it returns alot of info on the server side