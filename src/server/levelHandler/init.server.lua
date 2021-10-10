--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

Workspace:SetAttribute("PLAYER_LEVEL", 1)

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid
local getOrSetGlobalLevel = require(ReplicatedStorage:WaitForChild("Shared").utility.getOrSetGlobalLevel)

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local startLevel1Remote = remotesFolder.StartLevel1
local startLevel2Remote = remotesFolder.StartLevel2
local startLevel3Remote = remotesFolder.StartLevel3

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
