local CollectionService = game:GetService("CollectionService")
local WorkspaceService = game:GetService("Workspace")
local Cubert = WorkspaceService:WaitForChild("Cubert")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LightSpecificTileColor = Remotes:WaitForChild("LightSpecificTileColor")
local ResetGridFromBirdsEyeView = ReplicatedStorage:WaitForChild("Remotes").ResetGridFromBirdsEyeView

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUD = PlayerGui:WaitForChild("HUD")
local Controls = HUD:WaitForChild("Controls")
local ExitCubert = Controls:WaitForChild("ExitCubert")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local colorUIToggle = require(script.Parent.colorUIToggle)

local GenericTweenInformation = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local UserInputService = game:GetService("UserInputService")

local CubertWeld

local CubertPodium = {}

local function toggleProximityPrompts(toggle)
	for _, object in pairs(workspace:GetDescendants()) do
		if not object:IsA("ProximityPrompt") then
			continue
		end

		object.Enabled = toggle
	end
end

local function UnweldCubert()
	if CubertWeld then
		CubertWeld:Destroy()
		CubertWeld = nil
	end
	local Humanoid = Character:FindFirstChild("Humanoid")
	if Humanoid and Humanoid.WalkSpeed == 0 then
		Humanoid.WalkSpeed = 16
	end

	local Camera = WorkspaceService.CurrentCamera
	local TweenToPlayer = TweenService:Create(Camera, GenericTweenInformation, {
		CFrame = CFrame.new(
			Character:GetPivot().Position + (Character:GetPivot().UpVector * 2),
			Character:GetPivot().Position
		),
	})
	TweenToPlayer:Play()
	TweenToPlayer.Completed:Wait()
	Camera.CameraType = Enum.CameraType.Custom
end

local function WeldCubert(PromptParent)
	local PodiumBase = PromptParent.Parent:FindFirstChild("Base")
	local Base = PromptParent.Parent.Parent:FindFirstChild("Base")
	if CubertWeld then
		UnweldCubert()
	end
	Cubert:PivotTo(PodiumBase:GetPivot() + Vector3.new(0, Cubert.PrimaryPart.Size.Y / 2, 0))
	CubertWeld = Instance.new("WeldConstraint")
	CubertWeld.Part0 = Cubert.PrimaryPart
	CubertWeld.Part1 = PodiumBase
	CubertWeld.Parent = Cubert.PrimaryPart

	local Humanoid = Character:FindFirstChild("Humanoid")
	if Humanoid and Humanoid.WalkSpeed ~= 0 then
		Humanoid.WalkSpeed = 0
	end

	local Camera = WorkspaceService.CurrentCamera
	Camera.CameraType = Enum.CameraType.Scriptable
	local TweenToCubert = TweenService:Create(
		Camera,
		GenericTweenInformation,
		{ CFrame = CFrame.new(Base:GetPivot().Position + Vector3.new(0, 25, 0), Base:GetPivot().Position) }
	)
	TweenToCubert:Play()

	ExitCubert.Visible = true
	toggleProximityPrompts(false)
end

local function SetCubertText(IsEnabled)
	ExitCubert.Visible = IsEnabled
end

local LastPrompt = nil

local function ToggleCubertWeld(Prompt, PromptParent)
	if Cubert:GetAttribute("IS_WELDED") == true then
		UnweldCubert()
		Prompt.ActionText = "Add cubert"
		colorUIToggle.Disable()
		LightSpecificTileColor:FireServer("")
		SetCubertText(false)
	else
		WeldCubert(PromptParent)
		Prompt.ActionText = "Remove cubert"
		colorUIToggle.Enable()
		SetCubertText(true)
	end
	-- ToggleCubertText()
	-- Prompt.Enabled = not Prompt.Enabled
	Cubert:SetAttribute("IS_WELDED", not Cubert:GetAttribute("IS_WELDED"))
	LastPrompt = Prompt
end

CubertPodium.LoadPrompts = function()
	for _, prompt in pairs(workspace:GetDescendants()) do
		if not prompt:IsA("ProximityPrompt") then
			continue
		end

		prompt.Triggered:Connect(function()
			ToggleCubertWeld(prompt, prompt.Parent)
			toggleProximityPrompts(false)
			ExitCubert.Visible = true
		end)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	if
		input.UserInputType == Enum.UserInputType.Keyboard
		and input.KeyCode == Enum.KeyCode.E
		and ExitCubert.Visible == true
	then
		ToggleCubertWeld(LastPrompt, nil)
		ResetGridFromBirdsEyeView:FireServer()
		toggleProximityPrompts(true)
		ExitCubert.Visible = false
	end
end)

ExitCubert.TextButton.MouseButton1Click:Connect(function()
	ToggleCubertWeld(LastPrompt, nil)
	ResetGridFromBirdsEyeView:FireServer()
	toggleProximityPrompts(true)
	ExitCubert.Visible = false
	Controls.Cubug.Visible = false
end)

return CubertPodium
