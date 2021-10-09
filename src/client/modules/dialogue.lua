--[[
Dialogue.Lua

UI Layout:
    HUD (sGUI)
        -> Dialogue (Frame)
            -> Companion Image (ImageLabel)
            -> Dialogue Frames (Folder?)
                -> Custom Dialogue Frames (ImageLabels, tagged so that when one shows up, the others don't)
            -> Speaker
        -> Colors (Frame)
            -> UIListLayout (Horizontal, center x and y)
            -> Buttons for each color, account for 2 splits (RGB, CMY)
]]

local Dialogue = {}
local LocalPlayer = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer.PlayerGui

local GenericTweenInformation = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

--UI Elements
local HUD = PlayerGui:WaitForChild("HUD")
local DialogueMain = HUD:WaitForChild("DialogueMain")

local Emotes = {
    ["NEUTRAL"] = 0,
    ["ANGRY"] = 1,
    ["SARCASTIC"] = 2,
    ["JOY"] = 3,
}

local function TweenText(String) --Clears current box and replaces it with some string
    local 
end

Dialogue.Speak = function(String, EmoteEnum)
    if not Emotes[EmoteEnum] then
        EmoteEnum = 0 --Neutral
    else
        EmoteEnum = Emotes[EmoteEnum]
    end
    if DialogueMain.Visible == false then
        DialogueMain.Visible = true
        local DialogueTweenIn = TweenService:Create(DialogueMain, GenericTweenInformation, {Position = UDim2.fromScale(0.5, 0.83), BackgroundTransparency = 0})
        DialogueTweenIn:Play()
        DialogueTweenIn.Completed:Wait()
    end
    TweenText(String)
    --//TODO: Implement UI, images, etc
end

Dialogue.SpeakOther = function(String, EmoteEnum)
    --TODO: Implement speaking for other cube
end

return Dialogue