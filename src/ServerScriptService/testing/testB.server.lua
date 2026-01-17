local RunService = game:GetService("RunService")

local partA = workspace:FindFirstChild("A")
local partB = workspace:FindFirstChild("B")

if not partA or not partB then
	return
end

local initialDistance = (partA.Position - partB.Position).Magnitude
local currentDistance = initialDistance
local previousDistance = currentDistance

function printDistance()
	print((partA.Position - partB.Position).Magnitude)
end

printDistance()

RunService.Heartbeat:Connect(function()
	currentDistance = (partA.Position - partB.Position).Magnitude
	if previousDistance ~= currentDistance then
		printDistance()
	end
	previousDistance = currentDistance
end)

