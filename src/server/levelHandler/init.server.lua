--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid
local resetGrid = require(script.handleTiles).resetGrid
local LightSpecificTileColor = require(script.handleTiles).lightSpecificTileColor

local getOrSetGlobalLevel = require(ReplicatedStorage:WaitForChild("Shared").utility.getOrSetGlobalLevel)
local getTimeUntilAvailableReset = require(ReplicatedStorage:WaitForChild("Shared").utility.getTimeUntilAvailableReset)

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")

local startLevel1Remote = remotesFolder.StartLevel1
local startLevel2Remote = remotesFolder.StartLevel2
local startLevel3Remote = remotesFolder.StartLevel3
local startLevel4Remote = remotesFolder.StartLevel4
local resetLevelRemote = remotesFolder.ResetLevel

local LightRemote = remotesFolder.LightSpecificTileColor
local ToggleCubug = remotesFolder.ToggleCubug
local EnableCubug = remotesFolder.EnableCubug
local SkipLevel1 = remotesFolder.SkipLevel1
local Level1Complete = remotesFolder.Level1Complete
local Explosion = remotesFolder.Explosion
local ToggleColor = remotesFolder.ToggleColor
local ResetGridFromBirdsEyeView = remotesFolder.ResetGridFromBirdsEyeView

getOrSetGlobalLevel.setGlobalLevel(1)

local spawnLevel1 = false
local spawnLevel2 = false
local spawnLevel3 = false
local spawnLevel4 = false

startLevel1Remote.OnServerEvent:Connect(function()
	if spawnLevel1 then
		return
	end
	spawnLevel1 = true

	generateLevelGrid(1)
end)

startLevel2Remote.OnServerEvent:Connect(function()
	if spawnLevel2 then
		return
	end
	spawnLevel2 = true

	getOrSetGlobalLevel.setGlobalLevel(2)
	generateLevelGrid(2)
end)

startLevel3Remote.OnServerEvent:Connect(function()
	if spawnLevel3 then
		return
	end
	spawnLevel3 = true

	getOrSetGlobalLevel.setGlobalLevel(3)
	generateLevelGrid(3)
end)

startLevel4Remote.OnServerEvent:Connect(function()
	if spawnLevel4 then
		return
	end
	spawnLevel4 = true

	getOrSetGlobalLevel.setGlobalLevel(4)
	generateLevelGrid(4)
	EnableCubug:FireAllClients()
	local ServerStorage = game:GetService("ServerStorage")
	local Cubug = ServerStorage:WaitForChild("Cubug"):Clone()
	Cubug:PivotTo(game.Players:GetPlayers()[1].Character:GetPivot())
	Cubug.Parent = workspace
end)

resetLevelRemote.OnServerEvent:Connect(function()
	local timeUntilNextReset = getTimeUntilAvailableReset.getTimeUntilAvailableReset()
	if timeUntilNextReset ~= 0 then
		return
	end

	resetGrid(true)
end)

ToggleCubug.OnServerEvent:Connect(function(Player)
	Player:SetAttribute("CUBUG_ON", not Player:GetAttribute("CUBUG_ON"))
end)

SkipLevel1.OnServerEvent:Connect(function(player)
	Level1Complete:FireClient(player)
end)

Explosion.OnServerEvent:Connect(function(player)
	local character = player.Character

	local level1Folder = workspace:FindFirstChild("Level 1")
	local Lobby_NextLevelElevatorInside = level1Folder.NextLevelElevatorInside.Floor

	local forceField = Instance.new("ForceField")
	forceField.Parent = character

	local explosion = Instance.new("Explosion")
	explosion.Position = Lobby_NextLevelElevatorInside.Position
	explosion.BlastRadius = 30
	explosion.BlastPressure = 2
end)

ResetGridFromBirdsEyeView.OnServerEvent:Connect(function(player)
	resetGrid(false)
end)

local lastSelectedColor = ""
-- local lastReceived = 0
ToggleColor.OnServerEvent:Connect(function(player, specifiedColor)
	-- local now = time()
	-- if now - lastReceived < 0.4 then
	-- 	return
	-- end
	-- lastReceived = now

	player:SetAttribute("SELECTED_COLOR", specifiedColor)

	if not specifiedColor then
		return warn("No color")
	end

	if player:GetAttribute("CUBUG_ON") == true then
		specifiedColor = "Broken" .. specifiedColor
	end

	if specifiedColor == "" or (lastSelectedColor ~= "" and specifiedColor ~= lastSelectedColor) then
		resetGrid(false)
	end

	LightSpecificTileColor(specifiedColor)

	lastSelectedColor = specifiedColor
end)

game.Players.PlayerAdded:Connect(function(Player)
	Player:SetAttribute("CUBUG_ON", false)
	Player:SetAttribute("SELECTED_COLOR", "")
end)
