--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("Shared").levelConfig)

--- ( Service References ) ---
local tiles = ReplicatedStorage:WaitForChild("Tiles")

--- ( Private Variables ) ---
local gridState = {}
local totalTilesTouched = 0

local function findTile(position)
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

---@param position Vector3
---@param levelNumber number
---@param tileIndex number
local function handleTile(position, levelNumber, tileIndex)
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))

	local tileHolder = levelBuild:FindFirstChild("TileHolder")
	assert(tileHolder, string.format("Expected a folder/model named `TileHolder` for level %s", tostring(levelNumber)))

	-- clone and parent no-color tile and position it based off of the last spawned tiles position.
	local tileToHandle = tiles.Off:Clone()
	tileToHandle.Parent = tileHolder
	tileToHandle:SetPrimaryPartCFrame(CFrame.new(position.X, position.Y, position.Z))

	local gridData = {
		level = levelNumber,
		position = {
			X = tileToHandle.PrimaryPart.Position.X,
			Y = tileToHandle.PrimaryPart.Position.Y,
			Z = tileToHandle.PrimaryPart.Position.Z,
		},
	}
	table.insert(gridState, gridData)

	-- Assign tags via CollectionService based on the position of the tile and what level it's being spawned to.
	for colorName, tilePositionNumber in pairs(levelGridInformation.Colors) do
		if tilePositionNumber ~= tileIndex then
			CollectionService:AddTag(tileToHandle, "NoColor")
		end

		CollectionService:AddTag(tileToHandle, colorName)
	end

	-- Handle connections to the tile
	tileToHandle.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end

		local newTile = tiles.NoColor:Clone()
		newTile.Parent = tileHolder
		newTile:SetPrimaryPartCFrame(tileToHandle.Position)

		tileToHandle.Parent = nil
	end)

	return gridData
end

return {
	handleTile = handleTile,
	findTile = findTile,
}
