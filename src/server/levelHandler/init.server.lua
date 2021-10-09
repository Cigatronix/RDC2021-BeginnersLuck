--- ( Services ) ---
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Utility Functions ) ---
local generateLevelGrid = require(script.utility.generateLevelGrid).generateLevelGrid

--- ( Remotes ) ---
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local startGameRemote = remotesFolder.StartGame

startGameRemote.OnServerEvent:Connect(function(player)
	generateLevelGrid(1)
end)
