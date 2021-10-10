--[[
Dialogue.Lua

Handles the implementation of cubey's dialogue in-game. Does not handle their speech when interacted with.

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
local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RunService = game:GetService("RunService")

local GenericTweenInformation = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

--- ( Utility ) ---
local getOrSetGlobalLevel = require(ReplicatedStorage:WaitForChild("Shared").utility.getOrSetGlobalLevel)

--UI Elements
local HUD = PlayerGui:WaitForChild("HUD")
local DialogueMain = HUD:WaitForChild("DialogueMain")

local DialogueQueue = {}

local Emotes = {
	["NEUTRAL"] = "rbxassetid://7693330000",
	["ANGRY"] = "rbxassetid://7693970942",
	["SARCASTIC"] = "rbxassetid://7693966885",
	["JOY"] = "rbxassetid://7693966628",
}

local function TweenOutText()
	local TextBox = DialogueMain:FindFirstChild("TextFrame")
	local SpeakerName = DialogueMain:FindFirstChild("Speaker")
	if TextBox and TextBox.Text ~= "" then
		local Tween = TweenService:Create(TextBox, GenericTweenInformation, { MaxVisibleGraphemes = 0 })
		Tween:Play()
		Tween.Completed:Wait()
	end
	SpeakerName.Visible = false
end

local function TweenText(String) --Clears current box and replaces it with some string
	local TextBox = DialogueMain:FindFirstChild("TextFrame")
	local SpeakerName = DialogueMain:FindFirstChild("Speaker")
	TweenOutText()
	if TextBox.Visible ~= true then
		TextBox.Visible = true
	end
	TextBox.Text = String
	SpeakerName.Visible = true
	local TweenIn = TweenService:Create(TextBox, GenericTweenInformation, { MaxVisibleGraphemes = string.len(String) })
	TweenIn:Play()
end

local function TweenFace(Emote)
	local Face = HUD:FindFirstChild("SpeakerImage")
	if Face and Face.ImageTransparency == 1 then
		local FaceInTween = TweenService:Create(Face, GenericTweenInformation, { ImageTransparency = 0 })
		FaceInTween:Play()
	end
	Face.Image = Emotes[Emote]
end

local function TweenOutFace()
	local Face = HUD:FindFirstChild("SpeakerImage")
	if Face and Face.ImageTransparency == 0 then
		local FaceOutTween = TweenService:Create(Face, GenericTweenInformation, { ImageTransparency = 1 })
		FaceOutTween:Play()
	end
end

local function TweenOutMain()
	if DialogueMain.BackgroundTransparency == 0 then
		local DialogueTweenOut = TweenService:Create(
			DialogueMain,
			GenericTweenInformation,
			{ Position = UDim2.fromScale(0.6, 0.83), BackgroundTransparency = 1 }
		)
		DialogueTweenOut:Play()
	end
end

local function Speak(String, Emote) --Private speaking function. Also calls appropriate functions for tweening the text and face.
	if not Emotes[Emote] then
		Emote = "NEUTRAL"
	end
	if DialogueMain.BackgroundTransparency == 1 then
		local DialogueTweenIn = TweenService:Create(
			DialogueMain,
			GenericTweenInformation,
			{ Position = UDim2.fromScale(0.5, 0.83), BackgroundTransparency = 0 }
		)
		DialogueTweenIn:Play()
		DialogueTweenIn.Completed:Wait()
	end
	TweenText(String)
	TweenFace(Emote)
end

local function ClearQueue() -- Pops the front of the queue when the object is done displaying.
	if #DialogueQueue == 0 then
		return
	end
	-- warn(DialogueQueue[1]["Duration"] - time())
	if DialogueQueue[1]["Duration"] - time() <= 0 then
		if #DialogueQueue == 1 then --Last Item
			if DialogueQueue[1]["RemoteTag"] ~= nil then
				local Remote = Remotes:FindFirstChild(
					string.format("StartLevel%s", tostring(getOrSetGlobalLevel.getGlobalLevel()))
				)
				assert(
					Remote,
					string.format(
						"Cannot find remote to start level %s",
						tostring(getOrSetGlobalLevel.getGlobalLevel())
					)
				)

				if Remote then
					Remote:FireServer()
				else
					warn("Exception occured, unable to find remote")
				end
			end
		end
		table.remove(DialogueQueue, 1)
		if #DialogueQueue > 0 then
			DialogueQueue[1]["Duration"] += time()
			Speak(DialogueQueue[1]["String"], DialogueQueue[1]["Emote"])
		else
			TweenOutText()
			TweenOutFace()
			TweenOutMain()
		end
	end
end

Dialogue.Speak =
	function(String, Emote, Duration, RemoteTag) --Public facing speak function. This adds the object to the queue, and if empty, plays it.
		local TimeTotal = 0
		for _, Text in ipairs(DialogueQueue) do
			TimeTotal += Text["Duration"]
		end
		if #DialogueQueue == 0 then
			warn("Dialogue queue is 0 for " .. String)
			Duration += time()
			table.insert(
				DialogueQueue,
				{ ["String"] = String, ["Emote"] = Emote, ["Duration"] = Duration, ["RemoteTag"] = RemoteTag }
			) --TODO: Delet this
			Speak(DialogueQueue[1]["String"], DialogueQueue[1]["Emote"])
		else
			table.insert(
				DialogueQueue,
				{ ["String"] = String, ["Emote"] = Emote, ["Duration"] = Duration, ["RemoteTag"] = RemoteTag }
			)
		end
	end

Dialogue.SpeakOther = function(String, EmoteEnum)
	--TODO: Implement speaking for other cube
end

RunService.Heartbeat:Connect(ClearQueue)

return Dialogue
