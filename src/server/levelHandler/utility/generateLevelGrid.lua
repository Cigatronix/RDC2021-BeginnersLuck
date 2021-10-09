--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("Shared").levelConfig)

--- ( Utility Functions ) ---
local handleTile = require(script.Parent.handleTile).handleTile

--- ( Private Variables ) ---
local initialTileOffset = {
	X = 14,
	Y = 0.8,
	Z = 14,
}

local function spawnTile(previousTile, levelNumber, totalTilesSpawned)
	local nextTilePosition = {
		X = previousTile.X,
		Y = previousTile.Y,
		Z = previousTile.Z - 4,
	}

	local nextTile = handleTile(nextTilePosition, levelNumber, totalTilesSpawned)
	return nextTile
end

---@param levelNumber number
---Generates the grid for the level number passed.
local function generateLevelGrid(levelNumber)
	warn("GENERATING LEVEL " .. tostring(levelNumber))

	-- Verify that there is valid information for the requested level.
	local levelGridInformation = LevelConfig[levelNumber]
	assert(levelGridInformation, string.format("Expected to find grid information for level %s", tostring(levelNumber)))

	-- Verify that there is a model/folder or some container in workspace that holds the physical build for the level.
	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))
	assert(levelBuild, string.format("Expected to find level build container for level %s", tostring(levelNumber)))

	-- Verify that there is a "base" where tiles are spawned on top of inside the container for the level build.
	local tileBase = levelBuild:FindFirstChild("Base", true)
	assert(tileBase, string.format("Expected to find tile base named `Base` for level %s", tostring(levelNumber)))

	-- Get the constrained size of the level size [i.e: (6x6),(8x8),(10x10)].
	local constrainedSize = math.sqrt(levelGridInformation.SizeConstraint)

	-- Handle the spawn and tagging of the initial tile of the level.
	local initialTilePosition = {
		X = tileBase.Position.X + initialTileOffset.X,
		Y = tileBase.Position.Y + initialTileOffset.Y,
		Z = tileBase.Position.Z + initialTileOffset.Z,
	}

	-- Handle the spawning and tagging of all other tiles in the level.
	local lastTile = nil
	local totalTilesSpawned = 1
	for columnNumber = 1, constrainedSize, 1 do
		local initialTile
		if columnNumber == 1 then
			initialTile = handleTile(initialTilePosition, levelNumber, 1)
		else
			local newColumnInitialTilePosition = {
				X = lastTile.Position.X - 4,
				Y = lastTile.Position.Y,
				Z = lastTile.Position.Z + 28,
			}

			initialTile = handleTile(newColumnInitialTilePosition, levelNumber, totalTilesSpawned)
		end

		assert(
			initialTile,
			string.format("There was an issue while generating the first tile in column %s", tostring(columnNumber))
		)

		for _ = 2, constrainedSize - 1, 1 do
			totalTilesSpawned += 1

			local newTile = spawnTile(lastTile, levelNumber, totalTilesSpawned)
			lastTile = newTile
		end

		local endingTile = spawnTile(lastTile, levelNumber, totalTilesSpawned)
		lastTile = endingTile
	end
end

return {
	generateLevelGrid = generateLevelGrid,
}
