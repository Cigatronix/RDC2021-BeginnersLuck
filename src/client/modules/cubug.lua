--[[
Cubug.lua
]]

local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ToggleCubug = Remotes:WaitForChild("ToggleCubug")
local LightSpecificTileColor = Remotes:WaitForChild("LightSpecificTileColor")
local Controls = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Controls")
local ColorControls = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("ColorFrame"):WaitForChild("Cube1")

local Cubug = {}

local function ToggleCubugRemote()
	ToggleCubug:FireServer()
	if LocalPlayer:GetAttribute("SELECTED_COLOR") ~= "" then
		LightSpecificTileColor:FireServer(LocalPlayer:GetAttribute("SELECTED_COLOR"))
	end
end

local InCubug = false

local function ToggleCubugUI()
	InCubug = not InCubug
	if InCubug then
		ColorControls.BackgroundColor3 = Color3.fromRGB(255, 208, 0)
		ColorControls.TextLabel.Text = "Cubug! ^_^"
	else
		ColorControls.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ColorControls.TextLabel.Text = "Cubert"
	end
end

Cubug.Initialize = function()
	Controls.Cubug.Visible = true
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
			ToggleCubugRemote()
			Controls.Cubug.Visible = true
			ToggleCubugUI()
		end
	end)

	Controls.Cubug.TextButton.MouseButton1Click:Connect(function()
		ToggleCubugRemote()
		Controls.Cubug.Visible = true
		ToggleCubugUI()
	end)
end

return Cubug
