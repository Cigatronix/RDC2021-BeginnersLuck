--[[
    Testing code
]]
local Dialogue = require(script.modules.dialogue)
local Defaults = require(script.modules.defaults)
local ColorControls = require(script.modules.colorcontrols)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelDialogue = require(ReplicatedStorage.shared.strings.LevelDialogue)

-- wait(5)

-- local Test = {"ANGRY", "JOY", "SARCASTIC", "Test"}
-- for _, k in ipairs(Test) do
--     Dialogue.Speak("This is a test of "..k, k, 3)
-- end
-- wait(15)
-- Dialogue.Speak("Hello again", "ANGRY", 2)