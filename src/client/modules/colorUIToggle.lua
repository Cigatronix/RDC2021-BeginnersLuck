--[[
colorUIToggle.lua

Handles the UI end of colors from user input. 
]]

local CollectionService = game:GetService("CollectionService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local DefaultSize = UDim2.fromScale(0.7, 0.7)

local ToggleColor = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes").ToggleColor

local colorUIToggle = {}

local WorkspaceService = game:GetService("Workspace")
local Cubert = WorkspaceService:FindFirstChild("Cubert")

-- if LocalPlayer:GetAttribute("SELECTED_COLOR") == nil then
-- 	ToggleColor:FireServer("")
-- end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUD = PlayerGui:WaitForChild("HUD")
local ColorFrame = HUD:WaitForChild("ColorFrame")

-- local lastChecked = 0

colorUIToggle.Enable = function()
	ColorFrame.Visible = true
end

colorUIToggle.Disable = function()
	ColorFrame.Visible = false
end

colorUIToggle.ToggleColor = function(ColorName)
	-- local now = time()
	-- if now - lastChecked < 0.4 then
	-- 	return
	-- end
	-- lastChecked = now
	if Cubert:GetAttribute("IS_WELDED") ~= true then return end

	if LocalPlayer:GetAttribute("SELECTED_COLOR") == ColorName then
		for _, Button in ipairs(CollectionService:GetTagged("COLOR_BUTTON")) do
			Button.Size = DefaultSize
			ToggleColor:FireServer("")
		end
		return
	end

	for _, Button in ipairs(CollectionService:GetTagged("COLOR_BUTTON")) do
		if Button.Name ~= ColorName then
			Button.Size = DefaultSize
		else
			Button.Size = UDim2.fromScale(0.9, 0.9) --TODO: Tween lol
			if Button.Parent.Parent.Parent.Parent.Parent ~= game:GetService("StarterGui") then
				ToggleColor:FireServer(ColorName)
			end
		end
	end
end

return colorUIToggle
