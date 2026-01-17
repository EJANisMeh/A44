local SpleefGame = workspace:FindFirstChild("SpleefGame")
local Players = game:GetService("Players")

function Fade(part)
	
	for i = 0, 1, 0.1 do
		part.Transparency = i 
		wait(0.2)
	end
	part.CanCollide = false
	wait (1)
	part.Transparency = 0
	part.debounce.Value = false
	part.CanCollide = true
end

if SpleefGame then
	for _, part in pairs(SpleefGame:GetChildren()) do
		part.Touched:Connect(function(hit)
			if game.Players:GetPlayerFromCharacter(hit.Parent) then
				if not part.debounce.Value then
					part.debounce.Value = true
					Fade(part)
				end
			end
		end)
	end
end