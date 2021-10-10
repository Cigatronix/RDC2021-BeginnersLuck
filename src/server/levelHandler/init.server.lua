--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid
local resetGrid = require(script.handleTiles).resetGrid

local getOrSetGlobalLevel = require(ReplicatedStorage:WaitForChild("Shared").utility.getOrSetGlobalLevel)
local getTimeUntilAvailableReset = require(ReplicatedStorage:WaitForChild("Shared").utility.getTimeUntilAvailableReset)

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local startLevel1Remote = remotesFolder.StartLevel1
local startLevel2Remote = remotesFolder.StartLevel2
local startLevel3Remote = remotesFolder.StartLevel3
local resetLevelRemote = remotesFolder.ResetLevel

getOrSetGlobalLevel.setGlobalLevel(2)

--- ( Connections ) ---
startLevel1Remote.OnServerEvent:Connect(function()
	--getOrSetGlobalLevel.setGlobalLevel(1)
	--generateLevelGrid(1)
	getOrSetGlobalLevel.setGlobalLevel(2)
	generateLevelGrid(2)
end)

startLevel2Remote.OnServerEvent:Connect(function()
	getOrSetGlobalLevel.setGlobalLevel(2)
	generateLevelGrid(2)
end)

startLevel3Remote.OnServerEvent:Connect(function()
	getOrSetGlobalLevel.setGlobalLevel(3)
	generateLevelGrid(3)
end)

resetLevelRemote.OnServerEvent:Connect(function()
	local timeUntilNextReset = getTimeUntilAvailableReset.getTimeUntilAvailableReset()
	if timeUntilNextReset ~= 0 then
		return
	end

	resetGrid(true)
end)
