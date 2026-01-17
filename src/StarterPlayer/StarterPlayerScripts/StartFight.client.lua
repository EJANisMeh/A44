
--(( Varaibles ))--
local Players = game:GetService("Players")
local player = Players.LocalPlayer -- for the indivdual player that joins the roblox game --
local humanoid = player.CharacterAdded:Wait().Humanoid
local remote1 = game.ReplicatedStorage.SFight
local hitbox = game.ReplicatedStorage.Hitbox

local ToggleWeapon = game.ReplicatedStorage:WaitForChild("ToggleWeapon")
local root = player.Character:WaitForChild("HumanoidRootPart")
local ClassData = require(game.ReplicatedStorage.Data:WaitForChild("ClassData")) -- getting the data from module script
local classValue = player:WaitForChild("Class")
local playerClass = classValue.Value
local animId = ClassData[playerClass].M1Animation -- loads animation based on what class the player has
local cooldown = ClassData[playerClass]

local cd1 = false


local mouse = player:GetMouse() -- Gets the player's mouse
local M1AnimTrack

local function onButton1Down()
	if cd1 == false then
		cd1 = true
		ToggleWeapon:FireServer(true) -- weapon visiblity
		local M1Anim = Instance.new("Animation")
		M1Anim.AnimationId = animId
		M1AnimTrack = humanoid:LoadAnimation(M1Anim)
		M1AnimTrack.Priority = Enum.AnimationPriority.Action
		M1AnimTrack.Looped = false
		M1AnimTrack:Play()

			local function touche(part)
				print("Touched part:", part.Name)
				if part.Name == "monsterhitbox" then
					remote1:FireServer(part) -- send the part to server
				end
			end
		
		task.delay(1, function()
			ToggleWeapon:FireServer(false)
		end)
		
		wait(0.2)
		
		local look = root.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z).Unit
		local flatCFrame = CFrame.lookAt(root.Position, root.Position + flatLook)
		local hitboxC = hitbox:Clone()
		hitboxC.Parent = workspace
		hitboxC.CFrame = flatCFrame * CFrame.new(0, 0, -5)
		local weld = Instance.new("WeldConstraint")
		weld.Parent = hitboxC
		weld.Part0 = hitboxC
		weld.Part1 = player.Character.HumanoidRootPart
		
		hitboxC.Touched:Connect(touche) -- runs the function, 

		wait(0.8)
		hitboxC:Destroy()
		cd1 = false
	end
end


mouse.Button1Down:Connect(onButton1Down) -- Connects the function once M1 is pressed
