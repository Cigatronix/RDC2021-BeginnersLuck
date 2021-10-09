--[[
    Testing code
]]
local Dialogue = require(script.modules.dialogue)

wait(5)

local Test = {"ANGRY", "JOY", "SARCASTIC", "Test"}
for _, k in ipairs(Test) do
    Dialogue.Speak("This is a test of "..k, k, 3)
end