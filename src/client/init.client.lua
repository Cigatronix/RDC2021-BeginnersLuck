local Dialogue = require(script.modules.dialogue)
local Defaults = require(script.modules.defaults)
local ColorControls = require(script.modules.colorcontrols)
local CubertPodium = require(script.modules.cubertPodium)
local ElevatorControl = require(script.modules.elevatorControl)
local LevelDialogue = require(script.levelDialogue)

local Dialogue1 = LevelDialogue[1][1]
local Dialogue2 = LevelDialogue[1][2]
local Dialogue3 = LevelDialogue[1][3]
local Dialogue7 = LevelDialogue[4][1]
local Dialogue8 = LevelDialogue[5][1]
local Dialogue9 = LevelDialogue[6][1]
local Dialogue10 = LevelDialogue[6][2]
local Dialogue11 = LevelDialogue[7][1]

Dialogue.Speak(Dialogue1[1], Dialogue1[2], Dialogue1[3], Dialogue1[4], Dialogue1[5])
Dialogue.Speak(Dialogue2[1], Dialogue2[2], Dialogue2[3], Dialogue2[4])
Dialogue.Speak(Dialogue3[1], Dialogue3[2], Dialogue3[3], Dialogue3[4], Dialogue3[5])

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local level1Folder = workspace:FindFirstChild("Level 1")
local level2Folder = workspace:FindFirstChild("Level 2")
local level3Folder = workspace:FindFirstChild("Level 3")
local level4Folder = workspace:FindFirstChild("Level 4")

local instance1 = level1Folder.NextLevelElevatorInside.Floor
local instance2 = level2Folder.NextLevelElevatorInside.Floor
local instance3 = level3Folder.NextLevelElevatorInside.Floor

remotes.Level1Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel2TeleportElevator()

	instance1.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level2Folder.Level2Tele.Position)
		ElevatorControl.openLevel2Entrance()

		local remote = remotes:FindFirstChild("StartLevel2"):FireServer()

		Dialogue.Speak(Dialogue7[1], Dialogue7[2], Dialogue7[3], Dialogue7[4])
	end)
end)

remotes.Level2Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel3TeleportElevator()
	Dialogue.Speak(Dialogue8[1], Dialogue8[2], Dialogue8[3], Dialogue8[4])

	instance2.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level3Folder.Level3Tele.Position)
		ElevatorControl.openLevel3Entrance()
		local remote = remotes:FindFirstChild("StartLevel3"):FireServer()

		Dialogue.Speak(Dialogue9[1], Dialogue9[2], Dialogue9[3], Dialogue9[4])
		Dialogue.Speak(Dialogue10[1], Dialogue10[2], Dialogue10[3], Dialogue10[4])
	end)
end)

remotes.Level3Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel4TeleportElevator()

	instance3.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level4Folder.Level4Tele.Position)
		local remote = remotes:FindFirstChild("StartLevel4"):FireServer()

		ElevatorControl.openLevel4Entrance()
		Dialogue.Speak(Dialogue11[1], Dialogue11[2], Dialogue11[3], Dialogue11[4])
	end)
end)
