local CollectionService = game:GetService("CollectionService")
local WorkspaceService = game:GetService("Workspace")
local Cubert = WorkspaceService:WaitForChild("Cubert")

local CubertWeld

local CubertPodium = {}

local function UnweldCubert()
    if CubertWeld then
        CubertWeld:Destroy()
        CubertWeld = nil
    end
end

local function WeldCubert(PromptParent)
    if CubertWeld then 
        UnweldCubert() 
    end
    Cubert:PivotTo(PromptParent:GetPivot() + Vector3.new(0,Cubert.PrimaryPart.Y/2,0))
    CubertWeld = Instance.new("WeldConstraint")
    CubertWeld.Part0 = Cubert.PrimaryPart
    CubertWeld.Part1 = PromptParent
    CubertWeld.Parent = Cubert.PrimaryPart
end

local function ToggleCubertWeld(Prompt, PromptParent)
    if Cubert:GetAttribute("IS_WELDED") == true then
        UnweldCubert()
        Prompt.ActionText = "Add cubert"
    else
        WeldCubert(PromptParent)
        Prompt.ActionText = "Remove cubert"
    end
end

for _, Prompt in ipairs(CollectionService:GetTagged("CUBERT_PROMPT")) do
    Prompt.Triggered:Connect(function()
        ToggleCubertWeld(Prompt, Prompt.Parent)
    end)
end

return CubertPodium