--- ( Services ) ---
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("levelConfig"))

--- ( Private Functions ) ---

---@param levelNumber number
---Generates the grid for the level number passed.
local function generateLevelGrid(levelNumber)
	local levelGridInformation = LevelConfig[levelNumber]
	assert(levelGridInformation, string.format("Expected to find grid information for level %s", tostring(levelNumber)))

	local levelBuild = workspace:FindFirstChild(tostring(levelNumber))
	assert(levelBuild, string.format("Expected to find level build container for level %s", tostring(levelNumber)))

	local tileBase = levelBuild:FindFirstChild("Base", true)
	assert(tileBase, string.format("Expected to find tile base named `Base` for level %s", tostring(levelNumber)))

	local totalSize = math.sqrt(levelGridInformation.SizeConstraint)

	for i = 1, totalSize, 1 do
	end
end
