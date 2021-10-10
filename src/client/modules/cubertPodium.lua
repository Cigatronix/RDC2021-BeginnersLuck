local CollectionService = game:GetService("CollectionService")
local WorkspaceService = game:GetService("Workspace")
local Cubert = WorkspaceService:WaitForChild("Cubert")
local TweenService = game:GetService("TweenService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local colorUIToggle = require(script.Parent.colorUIToggle)

local GenericTweenInformation = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local CubertWeld

local CubertPodium = {}

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
    local TweenToPlayer = TweenService:Create(Camera, GenericTweenInformation, {CFrame = Character:GetPivot().Position + (Character:GetPivot().UpVector * 2)})
    TweenToPlayer:Play()
    TweenToPlayer.Completed:Wait()
    Camera.CameraType = Enum.CameraType.Custom
end

local function WeldCubert(PromptParent)
    if CubertWeld then 
        UnweldCubert() 
    end
    Cubert:PivotTo(PromptParent:GetPivot() + Vector3.new(0,Cubert.PrimaryPart.Size.Y/2,0))
    CubertWeld = Instance.new("WeldConstraint")
    CubertWeld.Part0 = Cubert.PrimaryPart
    CubertWeld.Part1 = PromptParent
    CubertWeld.Parent = Cubert.PrimaryPart

    --[[
        TODO:
            - Anchor player -> WalkSpeed 0 //
            - Fade to black (or maybe tween camera? /shrug)
            - UI on //TODO: Add tweening to color UI
            - View on --> It might just work by default?
            - Camera set to base //


            - Invisible player's cube //
            - Visible podium cube //
            --> Just weld it lmao
    ]]
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid and Humanoid.WalkSpeed ~= 0 then
        Humanoid.WalkSpeed = 0
    end

    local Camera = WorkspaceService.CurrentCamera
    Camera.CameraType = Enum.CameraType.Scriptable
    local TweenToCubert = TweenService:Create(Camera, GenericTweenInformation, {CFrame = Cubert:GetPivot()})
    TweenToCubert:Play()
    --TODO: Check if the thing is going to be facing forward, also how should we handle rotation?
end

local function ToggleCubertWeld(Prompt, PromptParent)
    if Cubert:GetAttribute("IS_WELDED") == true then
        UnweldCubert()
        Prompt.ActionText = "Add cubert"
        colorUIToggle.Disable()
    else
        WeldCubert(PromptParent)
        Prompt.ActionText = "Remove cubert"
        colorUIToggle.Enable()
    end
end

for _, Prompt in ipairs(CollectionService:GetTagged("CUBERT_PROMPT")) do
    Prompt.Triggered:Connect(function()
        ToggleCubertWeld(Prompt, Prompt.Parent)
    end)
end

return CubertPodium