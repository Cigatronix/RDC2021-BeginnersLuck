--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("Shared").levelConfig)

--- ( Service References ) ---
local tiles = ReplicatedStorage:WaitForChild("Tiles")

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

	-- Assign tags via CollectionService based on the position of the tile and what level it's being spawned to.
	for colorName, tilePositionNumber in pairs(levelGridInformation.Colors) do
		if tilePositionNumber ~= tileIndex then
			CollectionService:AddTag(tileToHandle, "NoColor")
		end

		CollectionService:AddTag(tileToHandle, colorName)
	end

	return tileToHandle
end

return {
	handleTile = handleTile,
}
