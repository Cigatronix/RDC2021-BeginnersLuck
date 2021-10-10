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

getOrSetGlobalLevel.setGlobalLevel(1)

--- ( Connections ) ---
startLevel1Remote.OnServerEvent:Connect(function()
	generateLevelGrid(1)
end)

startLevel2Remote.OnServerEvent:Connect(function()
	getOrSetGlobalLevel.setGlobalLevel(2)
	generateLevelGrid(2)
end)

startLevel3Remote.OnServerEvent:Connect(function()
	getOrSetGlobalLevel.setGlobalLevel(3)
	generateLevelGrid(3)
end)

startLevel4Remote.OnServerEvent:Connect(function()
	getOrSetGlobalLevel.setGlobalLevel(4)
	generateLevelGrid(4)
end)

LightRemote.OnServerEvent:Connect(function(_, color)
	LightSpecificTileColor(color)
end)

resetLevelRemote.OnServerEvent:Connect(function()
	local timeUntilNextReset = getTimeUntilAvailableReset.getTimeUntilAvailableReset()
	if timeUntilNextReset ~= 0 then
		return
	end

	resetGrid(true)
end)
