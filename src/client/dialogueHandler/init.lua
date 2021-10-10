--- ( Services ) ---
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

--- ( Loaded Modules ) ---
local Config = require(script.config)

--- ( Private Variables ) ---
local player = Players.LocalPlayer
local genericTweenInformation = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

local playerGui = player:WaitForChild("PlayerGui")
local hud = playerGui:WaitForChild("HUD")

--- ( Private Functions ) ---

---@param speakerName string
---@param dialogueIndex number
---@return table dialogueData
local function getDialogueData(speakerName, dialogueIndex)
	local speakerDialogueData = Config.DIALOGUE[speakerName]
	assert(speakerDialogueData, string.format("Expected to find dialogue data for speaker name: %s", speakerName))

	local dialogueData = speakerDialogueData[tostring(dialogueIndex)]
	assert(
		dialogueData,
		string.format(
			"Expected to find dialogue data of specified index %s for speaker %s",
			tostring(dialogueIndex),
			speakerName
		)
	)

	return dialogueData
end

---@param fadeIn boolean
local function dialogueBackground_fade(fadeIn)
	if fadeIn then
		local animateBackground = TweenService:Create(hud.DialogueMain, genericTweenInformation, {
			Position = UDim2.fromScale(0.5, 0.83),
			BackgroundTransparency = 0,
		})
		animateBackground:Play()
		animateBackground.Completed:Wait()
	else
		local animateBackground = TweenService:Create(hud.DialogueMain, genericTweenInformation, {
			Position = UDim2.fromScale(0.6, 0.83),
			BackgroundTransparency = 1,
		})
		animateBackground:Play()
		animateBackground.Completed:Wait()
	end
end

--- ( Public Functions ) ---

---@param speakerName string
---@param dialogueIndex number
---@param sequelText boolean
function displayDialogue(speakerName, dialogueIndex, sequelText)
	local dialogueData = getDialogueData(speakerName, dialogueIndex)

	hud.DialogueMain.Speaker.Text = speakerName
	hud.DialogueMain.Speaker.Visible = true

	if speakerName == "Cubert" then
		hud.SpeakerImage.Image = Config.EMOTES[dialogueData.Emotion]
		hud.SpeakerImage.Visible = true

		hud.SpeakerImage2.Visible = false
	elseif speakerName == "Cubug" then
		hud.SpeakerImage2.Image = Config.EMOTES[dialogueData.Emotion]
		hud.SpeakerImage2.Visible = true

		hud.SpeakerImage.Visible = false
	end

	if hud.DialogueMain.BackgroundTransparency ~= 0 then
		dialogueBackground_fade(true)
	end

	local animateSpeakerDecal = TweenService:Create(hud.SpeakerImage, genericTweenInformation, {
		ImageTransparency = 0,
	})
	animateSpeakerDecal:Play()
	animateSpeakerDecal.Completed:Wait()

	hud.DialogueMain.TextFrame.Text = dialogueData.Text
	hud.DialogueMain.TextFrame.Visible = true

	local animateText = TweenService:Create(hud.DialogueMain.TextFrame, genericTweenInformation, {
		MaxVisibleGraphemes = string.len(dialogueData.Text),
	})
	animateText:Play()
	animateText.Completed:Wait()

	task.wait(dialogueData.Duration)

	if not sequelText then
		hud.DialogueMain.Speaker.Visible = false
		hud.DialogueMain.TextFrame.Visible = false
		hud.SpeakerImage.Visible = false
		hud.SpeakerImage2.Visible = false

		dialogueBackground_fade(false)
	end
end

---@param value boolean
function setCoreGui(value)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, value)
end

return {
	displayDialogue = displayDialogue,
	setCoreGui = setCoreGui,
}
