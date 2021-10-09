--- ( Services ) ---
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("Shared").levelConfig)

--- ( Service References ) ---
local tiles = ReplicatedStorage:WaitForChild("Tiles")

--- ( Private Variables ) ---
local gridState = {}

--- ( Private Functions ) ---
local function getRequiredTiles(levelNumber)
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local requiredTiles = 0
	for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
		for _, positionNumber in pairs(tilePositionNumbers) do
			requiredTiles += 1
		end
	end

	return requiredTiles
end

local function checkProgress(levelNumber)
	local requiredTiles = getRequiredTiles(levelNumber)

	local totalTilesTouched = 0

	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		if gridData.isSelected then
			totalTilesTouched += 1
		end
	end

	print(totalTilesTouched, requiredTiles, not (totalTilesTouched > requiredTiles))
	return not (totalTilesTouched > requiredTiles)
end

local function validateAnswer(levelNumber)
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		local matches = false
		for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
			for _, positionNumber in pairs(tilePositionNumbers) do
				if positionNumber ~= gridData.tileIndex then
					continue
				end

				matches = true
			end
		end

		if not matches then
			return false
		end

		return true
	end
end

local function resetGrid(levelNumber)
	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))
	local tileHolder = levelBuild:FindFirstChild("TileHolder")

	local litTiles = CollectionService:GetTagged("LitTile")

	for _, tile in pairs(litTiles) do
		tile:Destroy()
	end

	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		gridData.isSelected = false
		gridData.initialTileObject.Parent = tileHolder
	end
end

--- ( Public Functions ) ---
---@param position table
function findTile(position)
	for _, gridData in pairs(gridState) do
		if gridData.position.X ~= position.X then
			continue
		end

		if gridData.position.Y ~= position.Y then
			continue
		end

		if gridData.position.Z ~= position.Z then
			continue
		end

		return gridData
	end

	return nil
end

---@param position table
---@param levelNumber number
---@param tileIndex number
function handleTile(position, levelNumber, tileIndex)
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))

	local tileHolder = levelBuild:FindFirstChild("TileHolder")
	assert(tileHolder, string.format("Expected a folder/model named `TileHolder` for level %s", tostring(levelNumber)))

	local playerStart = levelBuild:FindFirstChild("PlayerStart")
	assert(
		playerStart,
		string.format("Expected to find a part named `PlayerStart` for level %s", tostring(levelNumber))
	)

	-- clone and parent no-color tile and position it based off of the last spawned tiles position.
	local tileToHandle = tiles.Off:Clone()
	tileToHandle.Parent = tileHolder
	tileToHandle:SetPrimaryPartCFrame(CFrame.new(position.X, position.Y, position.Z))

	local gridData = {
		level = levelNumber,
		tileIndex = tileIndex,
		initialTileObject = tileToHandle,
		isSelected = false,
		position = {
			X = tileToHandle.PrimaryPart.Position.X,
			Y = tileToHandle.PrimaryPart.Position.Y,
			Z = tileToHandle.PrimaryPart.Position.Z,
		},
	}
	table.insert(gridState, gridData)

	-- Assign tags via CollectionService based on the position of the tile and what level it's being spawned to.
	for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
		local matches = false
		for _, positionNumber in pairs(tilePositionNumbers) do
			if positionNumber ~= tileIndex then
				continue
			end

			matches = true
		end

		if not matches then
			CollectionService:AddTag(tileToHandle, "NoColor")
		end

		CollectionService:AddTag(tileToHandle, colorName)
	end

	-- Handle connections to the tile
	tileToHandle.PrimaryPart.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end

		local humanoidRootPart = humanoid.RootPart

		local canSelectTile = checkProgress(levelNumber)
		if not canSelectTile then
			local isAnswerValid = validateAnswer(levelNumber)

			if not isAnswerValid then
				humanoidRootPart.CFrame = CFrame.new(playerStart.Position)
				resetGrid(levelNumber)
			else
				warn(string.format("Player has cleared Level %s", tostring(levelNumber)))
			end

			return
		end

		local newTile = tiles.NoColor:Clone()
		newTile.Parent = tileHolder
		newTile:SetPrimaryPartCFrame(tileToHandle.PrimaryPart.CFrame)

		CollectionService:AddTag(newTile, "LitTile")

		tileToHandle.Parent = nil
	end)

	return gridData
end

return {
	handleTile = handleTile,
	findTile = findTile,
}
