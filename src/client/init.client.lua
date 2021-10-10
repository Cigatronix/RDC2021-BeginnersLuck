local Dialogue = require(script.modules.dialogue)
local Defaults = require(script.modules.defaults)
local ColorControls = require(script.modules.colorcontrols)
local CubertPodium = require(script.modules.cubertPodium)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelDialogue = require(ReplicatedStorage.Shared.strings.levelDialogue)

--TODO: Remove in production, this is purely for testing the dialogue system with real data.
-- for _, DialogueTree in ipairs(LevelDialogue) do
--     for _, DialoguePiece in ipairs(DialogueTree) do
--         Dialogue.Speak(DialoguePiece[1], DialoguePiece[2], DialoguePiece[3], DialoguePiece[4])
--     end
-- end
--
local Dialogue1 = LevelDialogue[1][1]
local Dialogue2 = LevelDialogue[1][1]

Dialogue.Speak(Dialogue1[1], Dialogue1[2], Dialogue1[3], Dialogue1[4])
Dialogue.Speak(Dialogue2[1], Dialogue2[2], Dialogue2[3], Dialogue2[4])
