--- ( Services ) ---
local TweenService = game:GetService("TweenService")

--- ( Physical Object References ) ---
local lobbyFolder = workspace:FindFirstChild("Lobby")

--- ( Private Variables ) ---
local animationInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

--- ( Public Functions ) ---
function openLobbyElevator()
	local instance = lobbyFolder.LobbyEntrance

	local leftSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-66.659, 8.25, -290.696),
	})
	local rightSideAnimation = TweenService:Create(instance.Left, animationInfo, {
		Position = Vector3.new(-66.659, 8.25, -267.696),
	})
	leftSideAnimation:Play()
	rightSideAnimation:Play()
end
