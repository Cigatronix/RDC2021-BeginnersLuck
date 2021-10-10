--- ( Services ) ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--- ( Loaded Modules ) ---
local LevelConfig = require(ReplicatedStorage:WaitForChild("Shared").levelConfig)

--- ( Utility ) ---
local getOrSetGlobalLevel = require(ReplicatedStorage:WaitForChild("Shared").utility.getOrSetGlobalLevel)

--- ( Service References ) ---
local tiles = ReplicatedStorage:WaitForChild("Tiles")

--- ( Private Variables ) ---
local gridState = {}
local canStepLevel1 = true
local canStepLevel2 = true
local canStepLevel3 = true
local canStepLevel4 = true

--- ( Private Functions ) ---
local function tweenTile(tileObject, tweenDown)
	local animationInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local tweenData
	if tweenDown then
		local newPosition = Vector3.new(
			tileObject.PrimaryPart.Position.X,
			tileObject.PrimaryPart.Position.Y - 0.5,
			tileObject.PrimaryPart.Position.Z
		)

		tweenData = {
			CFrame = CFrame.new(newPosition),
		}
	else
		local newPosition = Vector3.new(
			tileObject.PrimaryPart.Position.X,
			tileObject.PrimaryPart.Position.Y + 0.5,
			tileObject.PrimaryPart.Position.Z
		)

		tweenData = {
			CFrame = CFrame.new(newPosition),
		}
	end

	local animation = TweenService:Create(tileObject.PrimaryPart, animationInfo, tweenData)
	animation:Play()
end

local function resetGrid(changeSelected)
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))
	local tileHolder = levelBuild:FindFirstChild("TileHolder")

	for _, tile in pairs(tileHolder:GetChildren()) do
		if tile.Name ~= "Off" and tile.Name ~= "Broken" then
			tile:Destroy()
		end
	end

	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		if changeSelected then
			gridData.isSelected = false
		end

		gridData.tileObject.Parent = tileHolder
	end
end

local function getRequiredTiles()
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local requiredTiles = 0
	for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
		for _, positionNumber in pairs(tilePositionNumbers) do
			requiredTiles += 1
		end
	end

	return requiredTiles
end

local function checkProgress()
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()
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

	return not (totalTilesTouched >= requiredTiles)
end

local function validateAnswer()
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local requiredTiles = getRequiredTiles()
	local matchingTiles = 0
	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
			for _, positionNumber in pairs(tilePositionNumbers) do
				if not gridData.isSelected then
					continue
				end

				if gridData.tileIndex ~= positionNumber then
					continue
				end

				matchingTiles += 1
			end
		end
	end

	return matchingTiles == requiredTiles
end

local function lightUpCorrectTiles()
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()
	local levelGridInformation = LevelConfig[tostring(levelNumber)]
	resetGrid(false)

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))

	local cubertStation = levelBuild:FindFirstChild("Cubert Podium")
	assert(
		cubertStation,
		string.format("Expected there to be a model named `Cubert Podium` for level %s", tostring(levelNumber))
	)

	local podiumWire = levelBuild:FindFirstChild("Podium Wire")
	assert(
		cubertStation,
		string.format("Expected there to be a model named `Podium Wire` for level %s", tostring(levelNumber))
	)

	local elevatorWire = levelBuild:FindFirstChild("Elevator Wire")
	assert(
		cubertStation,
		string.format("Expected there to be a model named `Elevator Wire` for level %s", tostring(levelNumber))
	)

	local elevatorDoor = levelBuild:FindFirstChild("NextLevelEntrance")
	assert(
		cubertStation,
		string.format("Expected there to be a model named `NextLevelEntrance` for level %s", tostring(levelNumber))
	)

	if levelNumber == 1 then
		canStepLevel1 = false

		elevatorDoor.Indicator.Color = Color3.fromRGB(85, 255, 127)

		for _, object in pairs(cubertStation:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(podiumWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(elevatorWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, gridData in pairs(gridState) do
			if gridData.level ~= levelNumber then
				continue
			end

			if not gridData.isSelected then
				continue
			end

			local finalTile = tiles.Green:Clone()
			finalTile.Parent = gridData.tileObject.Parent
			finalTile:SetPrimaryPartCFrame(gridData.tileObject.PrimaryPart.CFrame)
			tweenTile(finalTile, true)

			gridData.tileObject:Destroy()
			gridData.tileObject = finalTile
		end
	elseif levelNumber == 2 then
		canStepLevel2 = false

		elevatorDoor.Indicator.Color = Color3.fromRGB(85, 255, 127)

		for _, object in pairs(cubertStation:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(podiumWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(elevatorWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, gridData in pairs(gridState) do
			if gridData.level ~= levelNumber then
				continue
			end

			if not gridData.isSelected then
				continue
			end

			local finalTile = tiles.Green:Clone()
			finalTile.Parent = gridData.tileObject.Parent
			finalTile:SetPrimaryPartCFrame(gridData.tileObject.PrimaryPart.CFrame)
			tweenTile(finalTile, true)

			gridData.tileObject:Destroy()
			gridData.tileObject = finalTile
		end
	elseif levelNumber == 3 then
		canStepLevel3 = false

		elevatorDoor.Indicator.Color = Color3.fromRGB(85, 255, 127)

		for _, object in pairs(cubertStation:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(podiumWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(elevatorWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, gridData in pairs(gridState) do
			if gridData.level ~= levelNumber then
				continue
			end

			if not gridData.isSelected then
				continue
			end

			local finalTile
			for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
				for _, positionNumber in pairs(tilePositionNumbers) do
					if positionNumber ~= gridData.tileIndex then
						continue
					end

					finalTile = tiles:FindFirstChild(colorName):Clone()
				end
			end

			finalTile.Parent = gridData.tileObject.Parent
			finalTile:SetPrimaryPartCFrame(gridData.tileObject.PrimaryPart.CFrame)
			tweenTile(finalTile, true)

			gridData.tileObject:Destroy()
			gridData.tileObject = finalTile
		end

		elevatorDoor.Indicator.Color = Color3.fromRGB(85, 255, 127)

		for _, object in pairs(cubertStation:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(podiumWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(elevatorWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, gridData in pairs(gridState) do
			if gridData.level ~= levelNumber then
				continue
			end

			if not gridData.isSelected then
				continue
			end

			local finalTile = tiles.Green:Clone()
			finalTile.Parent = gridData.tileObject.Parent
			finalTile:SetPrimaryPartCFrame(gridData.tileObject.PrimaryPart.CFrame)
			tweenTile(finalTile, true)

			gridData.tileObject:Destroy()
			gridData.tileObject = finalTile
		end
	elseif levelNumber == 4 then
		canStepLevel4 = false

		elevatorDoor.Indicator.Color = Color3.fromRGB(85, 255, 127)

		for _, object in pairs(cubertStation:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(podiumWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, object in pairs(elevatorWire:GetDescendants()) do
			if object:IsA("BasePart") then
				if object.Color == Color3.fromRGB(255, 89, 89) then
					object.Color = Color3.fromRGB(85, 255, 127)
				end
			end
		end

		for _, gridData in pairs(gridState) do
			if gridData.level ~= levelNumber then
				continue
			end

			if not gridData.isSelected then
				continue
			end

			local finalTile
			for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
				for _, positionNumber in pairs(tilePositionNumbers) do
					if positionNumber ~= gridData.tileIndex then
						continue
					end

					finalTile = tiles:FindFirstChild(colorName):Clone()
				end
			end

			print(finalTile.Name, gridData.tileIndex)
			finalTile.Parent = gridData.tileObject.Parent
			finalTile:SetPrimaryPartCFrame(gridData.tileObject.PrimaryPart.CFrame)
			tweenTile(finalTile, true)

			gridData.tileObject:Destroy()
			gridData.tileObject = finalTile
		end
	end
end

--- ( Public Functions ) ---
function lightSpecificTileColor(specifiedColor)
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()
	local levelGridInformation = LevelConfig[tostring(levelNumber)]

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))
	local tileHolder = levelBuild:FindFirstChild("TileHolder")

	for _, gridData in pairs(gridState) do
		if gridData.level ~= levelNumber then
			continue
		end

		for colorName, tilePositionNumbers in pairs(levelGridInformation.Colors) do
			for _, positionNumber in pairs(tilePositionNumbers) do
				if colorName ~= specifiedColor then
					continue
				end

				if gridData.tileIndex ~= positionNumber then
					continue
				end

				local temporaryTile = tiles:FindFirstChild(specifiedColor):Clone()
				temporaryTile.Parent = tileHolder
				temporaryTile:PivotTo(gridData.tileObject.PrimaryPart.CFrame)
				gridData.tileObject.Parent = nil
			end
		end
	end
end

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
---@param tileIndex number
function handleTile(position, tileIndex, isBroken)
	local levelNumber = getOrSetGlobalLevel.getGlobalLevel()

	local levelBuild = workspace:FindFirstChild(string.format("Level %s", tostring(levelNumber)))

	local tileHolder = levelBuild:FindFirstChild("TileHolder")
	assert(tileHolder, string.format("Expected a folder/model named `TileHolder` for level %s", tostring(levelNumber)))

	local playerStart = levelBuild:FindFirstChild("PlayerStart")
	assert(
		playerStart,
		string.format("Expected to find a part named `PlayerStart` for level %s", tostring(levelNumber))
	)

	-- clone and parent no-color tile and position it based off of the last spawned tiles position.
	local tileToHandle
	if isBroken and levelNumber == 4 then
		tileToHandle = tiles.Broken:Clone()
	else
		tileToHandle = tiles.Off:Clone()
	end

	tileToHandle.Parent = tileHolder
	tileToHandle:SetPrimaryPartCFrame(CFrame.new(position.X, position.Y, position.Z))

	local gridData = {
		level = levelNumber,
		tileIndex = tileIndex,
		tileObject = tileToHandle,
		isSelected = false,
		position = {
			X = tileToHandle.PrimaryPart.Position.X,
			Y = tileToHandle.PrimaryPart.Position.Y,
			Z = tileToHandle.PrimaryPart.Position.Z,
		},
	}
	table.insert(gridState, gridData)

	-- Handle connections to the tile
	local resetTime = 0
	tileToHandle.PrimaryPart.Touched:Connect(function(hit)
		if gridData.level == 1 then
			if not canStepLevel1 then
				return
			end
		elseif gridData.level == 2 then
			if not canStepLevel2 then
				return
			end
		elseif gridData.level == 3 then
			if not canStepLevel3 then
				return
			end
		elseif gridData.level == 4 then
			if not canStepLevel4 then
				return
			end
		end

		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end

		local now = time()
		if now - resetTime < 1 then
			return
		end

		local humanoidRootPart = humanoid.RootPart

		gridData.isSelected = true

		local canSelectTile = checkProgress()
		if not canSelectTile then
			local isAnswerValid = validateAnswer()

			if not isAnswerValid then
				humanoidRootPart.CFrame = CFrame.new(playerStart.Position)

				task.delay(0.5, function()
					resetGrid(levelNumber, true)
				end)

				resetTime = time()

				return
			else
				lightUpCorrectTiles()
				return warn(string.format("Player has cleared Level %s", tostring(levelNumber)))
			end
		end

		local newTile
		if gridData.tileObject.Name == "Broken" then
			newTile = tiles.BrokenNoColor:Clone()
			print("Parenting new broken tile")
		else
			newTile = tiles.NoColor:Clone()
		end

		newTile.Parent = tileHolder
		newTile:SetPrimaryPartCFrame(tileToHandle.PrimaryPart.CFrame)
		tweenTile(newTile, true)

		tileToHandle.Parent = nil
	end)

	return gridData
end

return {
	handleTile = handleTile,
	findTile = findTile,
	lightSpecificTileColor = lightSpecificTileColor,
	resetGrid = resetGrid,
}
