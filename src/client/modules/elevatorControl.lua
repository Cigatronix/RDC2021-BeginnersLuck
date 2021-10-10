--- ( Services ) ---
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--- ( Physical Object References ) ---
local lobbyFolder = workspace:FindFirstChild("Lobby")
local level1Folder = workspace:FindFirstChild("Level 1")
local level2Folder = workspace:FindFirstChild("Level 2")
local level3Folder = workspace:FindFirstChild("Level 3")
local level4Folder = workspace:FindFirstChild("Level 4")

--- ( Private Variables ) ---
local animationInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

--- ( Public Functions ) ---
function openLobbyElevator()
	local instance = lobbyFolder.LobbyEntrance.Door
	local instance2 = lobbyFolder.NextLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-66.659, 8.25, -290.696),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(-66.659, 8.25, -267.696),
	})

	local leftSideAnimation2 = TweenService:Create(instance2.Left, animationInfo, {
		Position = Vector3.new(-15.509, 8.25, -290.696),
	})
	local rightSideAnimation2 = TweenService:Create(instance2.Right, animationInfo, {
		Position = Vector3.new(-15.509, 8.25, -267.696),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()

	leftSideAnimation2:Play()
	rightSideAnimation2:Play()
end

function openLevel1Entrance()
	local instance = level1Folder.PreviousLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -393.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -370.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel2TeleportElevator()
	local instance = level1Folder.NextLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -393.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -370.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel2Entrance()
	local instance = level2Folder.PreviousLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -489.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -466.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel3TeleportElevator()
	local instance = level2Folder.NextLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -466.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -489.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel3Entrance()
	local instance = level3Folder.PreviousLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -558.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -581.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel4TeleportElevator()
	local instance = level3Folder.NextLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -581.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(1.125, 8.25, -558.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

function openLevel4Entrance()
	local instance = level4Folder.PreviousLevelEntrance.Door

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -649.5),
	})
	local rightSideAnimation = TweenService:Create(instance.Right, animationInfo, {
		Position = Vector3.new(-75.025, 8.25, -672.5),
	})

	leftSideAnimation:Play()
	rightSideAnimation:Play()
end

return {
	openLobbyElevator = openLobbyElevator,
	openLevel1Entrance = openLevel1Entrance,
	openLevel2TeleportElevator = openLevel2TeleportElevator,
	openLevel2Entrance = openLevel2Entrance,
	openLevel3TeleportElevator = openLevel3TeleportElevator,
	openLevel3Entrance = openLevel3Entrance,
	openLevel4TeleportElevator = openLevel4TeleportElevator,
	openLevel4Entrance = openLevel4Entrance,
}
