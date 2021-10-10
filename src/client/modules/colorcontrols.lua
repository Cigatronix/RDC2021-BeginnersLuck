--[[
ColorControls

Keybinds and buttons to toggle client-side view of color control
]]
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local colorUIToggle = require(script.Parent.colorUIToggle)

local Keybinds = {
	Enum.KeyCode.One,
	Enum.KeyCode.Two,
	Enum.KeyCode.Three,
}

local ColorCodes = {
	"Red",
	"Green",
	"Blue",
}

local ColorControls = {}

local function SinkInput(InputObject, HasBeenHandled)
	if HasBeenHandled then
		return
	end
	if InputObject.UserInputType == Enum.UserInputType.Keyboard then
		local keyPosition = table.find(Keybinds, InputObject.KeyCode)
		if keyPosition then
			colorUIToggle.ToggleColor(ColorCodes[keyPosition])
		end
	end
end

ColorControls.HandleColorButtons = function()
	for _, Object in ipairs(CollectionService:GetTagged("COLOR_BUTTON")) do
		Object.MouseButton1Click:Connect(function()
			colorUIToggle.ToggleColor(Object.Name)
		end)
	end
end

UserInputService.InputBegan:Connect(SinkInput)

return ColorControls
