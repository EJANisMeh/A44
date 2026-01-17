--Base code by ThanksRoBama. Built upon & compiled together by BADGRAPHIX.
--Published 11/19/2019
--1. Put the parent GUI of this script into StarterGui.
--2. Ensure the Borders frame is in a ScreenGui where IgnoreGuiInsert = true.
--3. Change the variables to your liking.
local camera = workspace.CurrentCamera

--Note that if you want to change any of these variables, you will need to read ADVANCED SETUP below.
local ASPECT_RATIO = 16/9
local intendedVerticalFov = 70 --The vertical FoV at the intended aspect ratio.
local intendedHorizontalFov = nil --102.41872105292 --The intended horizontal FoV for default settings.

--ADVANCED SETUP (optional)--
--To use this script outside of the default settings, do the following:
--1. Modify ASPECT_RATIO and intendedVerticalFov to your liking.
--2. Set intendedHorizontalFov = nil
--3. Run the game in the aspect ratio you'd like to force. (I recommend using Test->Emulator in the Studio menu if you want to mimic the aspect ratio of a certain device.)
--4. Copy the number printed in the output and make that the new intendedHorizontalFov.
--5. YOU'RE ALL SET! 

local function getAspectRatio(camera)
	return camera.ViewportSize.X / camera.ViewportSize.Y
end
function getVerticalFov(camera)
	return camera.FieldOfView
end
function getHorizontalFov(camera)
	local z = camera.NearPlaneZ
	local viewSize = camera.ViewportSize
	
	local r0, r1 = 
		camera:ViewportPointToRay(viewSize.X*0, viewSize.Y/2, z), 
		camera:ViewportPointToRay(viewSize.X*1, viewSize.Y/2, z)
		
	return math.deg(math.acos(r0.Direction.Unit:Dot(r1.Direction.Unit)))
end
function setVerticalFov(camera, fov)
	camera.FieldOfView = fov
end
function setHorizontalFov(camera, fov)
	local aspectRatio = getHorizontalFov(camera)/getVerticalFov(camera)
	
	camera.FieldOfView = fov / aspectRatio
end

function forceAspectRatio()
	script.Parent.UIAspectRatioConstraint.AspectRatio = ASPECT_RATIO
	if intendedHorizontalFov then
		while true do
			if getAspectRatio(camera) > ASPECT_RATIO then --Wide
				setVerticalFov(camera, intendedVerticalFov)
			else --Tall
				setHorizontalFov(camera, intendedHorizontalFov)
			end
			wait()
		end
	else --Advanced setup
		setVerticalFov(camera, intendedVerticalFov)
		print("If you started your game up in the aspect ratio you intend to force, copy this number into intendedHorizontalFov: " .. getHorizontalFov(camera))
	end
end

forceAspectRatio()