local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local resetLevelRemote = ReplicatedStorage:WaitForChild("Remotes").ResetLevel

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.R then
		return
	end

	resetLevelRemote:FireServer()
end)
