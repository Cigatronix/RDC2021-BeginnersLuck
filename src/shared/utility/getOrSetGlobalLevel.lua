local Workspace = game:GetService("Workspace")

local function getGlobalLevel()
	return Workspace:GetAttribute("Level")
end

local function setGlobalLevel(levelNumber)
	Workspace:SetAttribute("Level", levelNumber)
end

return {
	getGlobalLevel = getGlobalLevel,
	setGlobalLevel = setGlobalLevel,
}
