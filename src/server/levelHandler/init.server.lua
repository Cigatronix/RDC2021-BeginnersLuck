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

getOrSetGlobalLevel.setGlobalLevel(1)

--- ( Connections ) ---
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
end)

local LastSelectedColor = ""

LightRemote.OnServerEvent:Connect(function(Player, color)
	if Player:GetAttribute("CUBUG_ON") == true then
		color = "Broken"..color
	end
	if color == "" or (LastSelectedColor ~= "" and color ~= LastSelectedColor) then
		resetGrid(false)
	end
	LightSpecificTileColor(color)
	LastSelectedColor = color
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

game.Players.PlayerAdded:Connect(function(Player)
	Player:SetAttribute("CUBUG_ON", false)
end)