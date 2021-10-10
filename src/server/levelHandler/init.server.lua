--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

Workspace:SetAttribute("PLAYER_LEVEL", 1)

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local startLevel1Remote = remotesFolder.StartLevel1
local startLevel2Remote = remotesFolder.StartLevel2
local startLevel3Remote = remotesFolder.StartLevel3

startLevel1Remote.OnServerEvent:Connect(function()
	generateLevelGrid(1)
end)

startLevel2Remote.OnServerEvent:Connect(function()
	generateLevelGrid(2)
end)

startLevel3Remote.OnServerEvent:Connect(function()
	generateLevelGrid(3)
end)

generateLevelGrid(1)
