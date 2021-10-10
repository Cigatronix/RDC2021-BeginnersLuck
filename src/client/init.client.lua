local Dialogue = require(script.modules.dialogue)
local Defaults = require(script.modules.defaults)
local ColorControls = require(script.modules.colorcontrols)
local CubertPodium = require(script.modules.cubertPodium)
local ElevatorControl = require(script.modules.elevatorControl)
local LevelDialogue = require(script.levelDialogue)

local Dialogue1 = LevelDialogue[1][1]
local Dialogue2 = LevelDialogue[1][2]
local Dialogue3 = LevelDialogue[1][3]

Dialogue.Speak(Dialogue1[1], Dialogue1[2], Dialogue1[3], Dialogue1[4], Dialogue1[5])
Dialogue.Speak(Dialogue2[1], Dialogue2[2], Dialogue2[3], Dialogue2[4])
Dialogue.Speak(Dialogue3[1], Dialogue3[2], Dialogue3[3], Dialogue3[4], Dialogue3[5])

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local level1Folder = workspace:FindFirstChild("Level 1")
local level2Folder = workspace:FindFirstChild("Level 2")
local instance = level1Folder.NextLevelElevatorInside.Floor
remotes.Level1Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel2TeleportElevator()

	instance.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level2Folder.Level2Tele.Position)
		ElevatorControl.openLevel2Entrance()
	end)
end)
