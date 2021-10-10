--- ( Services ) ---
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--- ( Loaded Modules ) ---
local client = require(script.Parent)

--- ( Service References ) ---
local player = Players.LocalPlayer
local points = ReplicatedStorage:WaitForChild("Points")
local uiBlur = Lighting:WaitForChild("UIBlur")

--- ( Interface ) ---
local playerGui = player:WaitForChild("PlayerGui")
local idle = playerGui:WaitForChild("Idle")

--- ( Private Variables ) ---
local camera = workspace.CurrentCamera
local generalTween = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local playLoading = true

local currentTween = nil

--- ( Module ) ---
local function tweenCamera(parts)
	camera.CameraType = Enum.CameraType.Custom

	local distance = (parts[1].Position - parts[2].Position).Magnitude
	local timeOfTween = distance / 2

	camera.CFrame = parts[1].CFrame

	local animationInfo = TweenInfo.new(timeOfTween, Enum.EasingStyle.Sine)
	local animation = TweenService:Create(camera, animationInfo, {
		CFrame = parts[2].CFrame,
	})
	return animation
end

local function tweenUIBlur(enabled)
	if enabled then
		uiBlur.Enabled = true
		TweenService
			:Create(uiBlur, generalTween, {
				Size = 15,
			})
			:Play()
	else
		local animation = TweenService:Create(uiBlur, generalTween, {
			Size = 0,
		})

		animation:Play()
		animation.Completed:Wait()

		uiBlur.Enabled = false
	end
end

function playIdleAnim(loading)
	if loading then
		idle.PlayButton.MouseButton1Down:Connect(function()
			local animatedPosition = UDim2.new(0.492, 0, 0.754, 0)
			local animatedSize = UDim2.new(0.236, 0, 0.141, 0)

			local animation = TweenService:Create(idle.PlayButton, generalTween, {
				Position = animatedPosition,
				Size = animatedSize,
			})
			animation:Play()
			animation.Completed:Wait()
		end)

		idle.PlayButton.MouseButton1Up:Connect(function()
			local animatedPosition = UDim2.new(0.492, 0, 0.755, 0)
			local animatedSize = UDim2.new(0.277, 0, 0.166, 0)

			local animation = TweenService:Create(idle.PlayButton, generalTween, {
				Position = animatedPosition,
				Size = animatedSize,
			})
			animation:Play()
			animation.Completed:Wait()

			if currentTween then
				currentTween:Cancel()
			end

			tweenUIBlur(false)
			idle.Enabled = false
			camera.CameraType = Enum.CameraType.Custom
			playLoading = false

			idle.Parent.HUD.Enabled = true

			client.start()
		end)

		idle.PlayButton.MouseEnter:Connect(function()
			local animatedPosition = UDim2.new(0.492, 0, 0.754, 0)
			local animatedSize = UDim2.new(0.302, 0, 0.181, 0)

			local animation = TweenService:Create(idle.PlayButton, generalTween, {
				Position = animatedPosition,
				Size = animatedSize,
			})
			animation:Play()
			animation.Completed:Wait()
		end)

		idle.PlayButton.MouseLeave:Connect(function()
			local animatedPosition = UDim2.new(0.492, 0, 0.755, 0)
			local animatedSize = UDim2.new(0.277, 0, 0.166, 0)

			local animation = TweenService:Create(idle.PlayButton, generalTween, {
				Position = animatedPosition,
				Size = animatedSize,
			})
			animation:Play()
			animation.Completed:Wait()
		end)
	else
		idle.PlayButton.Visible = false
		idle.Thanks.Visible = true
		idle.Logo.Position = UDim2.new(0.5, 0, 0.444, 0)
	end
end

playIdleAnim(true)

while true do
	if not playLoading then
		break
	end

	if uiBlur.Size ~= 24 then
		tweenUIBlur(true)
	end

	for _, group in pairs(points:GetChildren()) do
		local cameraTween = tweenCamera(group:GetChildren())

		cameraTween:Play()

		currentTween = cameraTween
	end

	task.wait(5)
end
