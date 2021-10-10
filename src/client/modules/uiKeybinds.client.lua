local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Controls = PlayerGui:WaitForChild("HUD"):WaitForChild("Controls")

local resetLevelRemote = ReplicatedStorage:WaitForChild("Remotes").ResetLevel

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.R then
		resetLevelRemote:FireServer()
	end
end)

Controls:WaitForChild("Restart").MouseButton1Click:Connect(function()
	resetLevelRemote:FireServer()
end)
