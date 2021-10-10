--- ( Services ) ---
local TweenService = game:GetService("TweenService")

--- ( Physical Object References ) ---
local lobbyFolder = workspace:FindFirstChild("Lobby")

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

return {
	openLobbyElevator = openLobbyElevator,
}
