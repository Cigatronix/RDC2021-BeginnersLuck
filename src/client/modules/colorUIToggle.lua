--[[
colorUIToggle.lua

Handles the UI end of colors from user input. 
]]

local CollectionService = game:GetService("CollectionService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local DefaultSize = UDim2.fromScale(0.7, 0.7)

local colorUIToggle = {}

local Stage2Colors = {"Cyan", "Magenta", "Yellow"}
if LocalPlayer:GetAttribute("SELECTED_COLOR") == nil then 
    LocalPlayer:SetAttribute("SELECTED_COLOR", "") 
end

colorUIToggle.ToggleColor = function(ColorName)
    if table.find(Stage2Colors, ColorName) then
        if LocalPlayer:GetAttribute("HAS_SPLIT") == nil or LocalPlayer:GetAttribute("HAS_SPLIT") == false then --Player has pressed the button before unlocking stage 2
            return
        end
    end
    if LocalPlayer:GetAttribute("SELECTED_COLOR") == ColorName then
        for _, Button in ipairs(CollectionService:GetTagged("COLOR_BUTTON")) do
            Button.Size = DefaultSize
            LocalPlayer:SetAttribute("SELECTED_COLOR", "")
        end
        return
    end

    for _, Button in ipairs(CollectionService:GetTagged("COLOR_BUTTON")) do
        if Button.Name ~= ColorName then
           Button.Size = DefaultSize
        else
            Button.Size = UDim2.fromScale(0.9, 0.9) --TODO: Tween lol
            LocalPlayer:SetAttribute("SELECTED_COLOR", ColorName)
        end
    end
end

return colorUIToggle