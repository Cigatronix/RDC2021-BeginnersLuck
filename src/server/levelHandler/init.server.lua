--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.generateLevelGrid).generateLevelGrid

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local startGameRemote = remotesFolder.StartGame

startGameRemote.OnServerEvent:Connect(function()
	generateLevelGrid(1)
end)

generateLevelGrid(1)
