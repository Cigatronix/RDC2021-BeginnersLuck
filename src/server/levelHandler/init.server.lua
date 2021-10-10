--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

Workspace:SetAttribute("PLAYER_LEVEL", 1)

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
-- local startGameRemote = remotesFolder.StartGame
local Level1StartRemote = remotesFolder.StartLevel1

Level1StartRemote.OnServerEvent:Connect(function()
	generateLevelGrid(1)
end)

-- generateLevelGrid(1)
