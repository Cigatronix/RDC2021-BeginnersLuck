--[[
Defaults.lua

Just some stuff to disable in-game, mostly CoreGui, maybe some stuff down the line
]]

local StarterGui = game:GetService("StarterGui")

local Defaults = {}

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

return Defaults