--- ( Services ) ---
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--- ( Loaded Modules ) ---
local ElevatorControl = require(script.elevatorControl)
local DialogueHandler = require(script.dialogueHandler)
local Cubug = require(script.modules.cubug)
local CubertPoduim = require(script.modules.cubertPodium)
local ColorControls = require(script.modules.colorcontrols)

--- ( Service References ) ---
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local lobbyFolder = workspace:FindFirstChild("Lobby")
local level1Folder = workspace:FindFirstChild("Level 1")
local level2Folder = workspace:FindFirstChild("Level 2")
local level3Folder = workspace:FindFirstChild("Level 3")
local level4Folder = workspace:FindFirstChild("Level 4")

--- ( Remotes ) ---
local level1Complete = remotes.Level1Complete
local level2Complete = remotes.Level2Complete
local level3Complete = remotes.Level3Complete
local level4Complete = remotes.Level4Complete

local startLevel1 = remotes.StartLevel1
local startLevel2 = remotes.StartLevel2
local startLevel3 = remotes.StartLevel3
local startLevel4 = remotes.StartLevel4

local skipLevel1 = remotes.SkipLevel1
local explosion = remotes.Explosion

local enabledCubugRemote = remotes.EnableCubug

--- ( Interface ) ---
local playerGui = player:WaitForChild("PlayerGui")
local hud = playerGui:WaitForChild("HUD")

--- ( Private Variables ) ---
local hasInteractedWithLobbyDoor = false
local Lobby_NextLevelElevatorInside = lobbyFolder.NextLevelElevatorInside.Floor
local Level1_NextLevelElevatorInside = level1Folder.NextLevelElevatorInside.Floor

local instance1 = level1Folder.NextLevelElevatorInside.Floor
local instance2 = level2Folder.NextLevelElevatorInside.Floor
local instance3 = level3Folder.NextLevelElevatorInside.Floor

--- ( Module Start ) ===
local function start()
	DialogueHandler.setCoreGui(false)

	CubertPoduim.LoadPrompts()
	ColorControls.HandleColorButtons()

	DialogueHandler.displayDialogue("Cubert", 1, true)
	DialogueHandler.displayDialogue("Cubert", 2, true)
	DialogueHandler.displayDialogue("Cubert", 3, false)
	ElevatorControl.openLobbyElevator()
end

--- ( Connections ) ---
Lobby_NextLevelElevatorInside.Touched:Connect(function(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	local humanoidRootPart = humanoid.RootPart
	humanoidRootPart.CFrame = CFrame.new(level1Folder.Level1Tele.Position)

	DialogueHandler.displayDialogue("Cubert", 4, true)
	DialogueHandler.displayDialogue("Cubert", 5, false)

	ElevatorControl.openLevel1Entrance()

	DialogueHandler.displayDialogue("Cubert", 6, false)
	startLevel1:FireServer()
end)

level1Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel2TeleportElevator()

	DialogueHandler.displayDialogue("Cubert", 69, false)

	instance1.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level2Folder.Level2Tele.Position)
		ElevatorControl.openLevel2Entrance()
		startLevel2:FireServer()

		DialogueHandler.displayDialogue("Cubert", 7, true)
		DialogueHandler.displayDialogue("Cubert", 71, true)
		DialogueHandler.displayDialogue("Cubert", 72, false)
	end)
end)

level2Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel3TeleportElevator()

	DialogueHandler.displayDialogue("Cubert", 8, false)

	instance2.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild("Humanoid") then
			return
		end

		local humanoidRootPart = hit.Parent:FindFirstChild("Humanoid").RootPart

		humanoidRootPart.CFrame = CFrame.new(level3Folder.Level3Tele.Position)
		ElevatorControl.openLevel3Entrance()
		startLevel3:FireServer()

		DialogueHandler.displayDialogue("Cubert", 8, false)
	end)
end)

level3Complete.OnClientEvent:Connect(function()
	ElevatorControl.openLevel4TeleportElevator()

	DialogueHandler.displayDialogue("Cubert", 91, false)

	instance3.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end

		local humanoidRootPart = humanoid.RootPart
		humanoidRootPart.CFrame = CFrame.new(level4Folder.Level4Tele.Position)

		ElevatorControl.openLevel4Entrance()
		startLevel4:FireServer()

		DialogueHandler.displayDialogue("Cubert", 92, true)
		DialogueHandler.displayDialogue("Cubug", 93, true)
		DialogueHandler.displayDialogue("Cubert", 94, true)
		DialogueHandler.displayDialogue("Cubug", 95, true)
		DialogueHandler.displayDialogue("Cubert", 96, true)
		DialogueHandler.displayDialogue("Cubug", 97, true)
		DialogueHandler.displayDialogue("Cubug", 98, false)
	end)
end)

level4Complete.OnClientEvent:Connect(function()
	hud.Parent.Idle.Enabled = false
	hud.Parent.BSOD.Enabled = true

	DialogueHandler.displayDialogue("Cubug", 99, true)
	DialogueHandler.displayDialogue("Cubert", 991, true)
	DialogueHandler.displayDialogue("Cubug", 992, true)
	DialogueHandler.displayDialogue("Cubert", 993, false)
end)

enabledCubugRemote.OnClientEvent:Connect(function()
	Cubug.Initialize()
end)

RunService.Heartbeat:Connect(function()
	if hasInteractedWithLobbyDoor then
		return
	end

	local character = player.Character

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	local humanoidRootPart = humanoid.RootPart

	local distance = (humanoidRootPart.Position - Level1_NextLevelElevatorInside.Position).Magnitude
	if distance > 20 then
		return
	end

	explosion:FireServer()

	hasInteractedWithLobbyDoor = true
	skipLevel1:FireServer()
end)

return {
	start = start,
}
