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

local Cubug = {}

local function ToggleCubugRemote()
    ToggleCubug:FireServer()
    if LocalPlayer:GetAttribute("SELECTED_COLOR") ~= "" then
        LightSpecificTileColor:FireServer(LocalPlayer:GetAttribute("SELECTED_COLOR"))
    end
end

Cubug.Initialize = function()
    Controls.Cubug.Visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
            ToggleCubugRemote()
        end
    end)

    Controls.Cubug.TextButton.MouseButton1Click:Connect(function()
        ToggleCubugRemote()
    end)
end


return Cubug