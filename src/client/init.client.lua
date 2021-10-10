local Dialogue = require(script.modules.dialogue)
local Defaults = require(script.modules.defaults)
local ColorControls = require(script.modules.colorcontrols)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelDialogue = require(ReplicatedStorage.Shared.strings.levelDialogue)

--TODO: Remove in production, this is purely for testing the dialogue system with real data.
-- for _, DialogueTree in ipairs(LevelDialogue) do
--     for _, DialoguePiece in ipairs(DialogueTree) do
--         Dialogue.Speak(DialoguePiece[1], DialoguePiece[2], DialoguePiece[3], DialoguePiece[4])
--     end
-- end
--
local StartLevel = LevelDialogue[3]

Dialogue.Speak(StartLevel[1], StartLevel[2], StartLevel[3], StartLevel[4])