--[[
    levelDialogue.lua

    Strings mainly. For the companion cube to say.
]]

local ElevatorControl = require(script.Parent.modules.elevatorControl)

local LevelDialogue = {
	{
		{ "Hey there!", "JOY", 5, ElevatorControl.openLobbyElevator() },
		{ "Looks like you're new around here, huh?", "SARCASTIC", 5 },
		{
			"But let's get started anyways! Step into the elevator to begin.",
			"",
			5,
		},
	},
	{
		{ "Welcome to the Tile Trials! I hope you're ready to solve some puzzles.", "", 5 },
		{ "Because if you're not...you're gonna have a bad time.", "SARCASTIC", 5 },
	},
	{
		{
			"Here's the deal - step on these buttons in the right pattern, and you get to move on! Simple as that.",
			"NEUTRAL",
			5,
			true,
		},
	},
	{
		{ "Hopefully this works this time... Try to step on the colored tiles again.", "NEUTRAL", 5, true },
	},
	{
		{ "Nice job, you did it! But it won't be this simple next time.", "JOY", 5 },
	},
	{
		{ "For this one, you'll have to put me at the station to check which tiles are correct.", "NEUTRAL", 5, true },
		{ "..Don't put me down anywhere else. Please.", "ANGRY", 5 },
	},
	{
		{ "Nice one. Hopefully the next one won't take you too long.", "NEUTRAL", 5 },
	},
}

local MiscellaneousDialogue = {
	["Level1Broken"] = {
		{ "Wait, why isn't it resetting? That isn't supposed to happen.", "", 5 },
		{ "Is the door system broken? Try to open it.", "", 5 },
	},
	["Level1DoorExplosion"] = {
		{ "Woah! Uh, I guess that works. I guess we'll, er...move on?", "", 5 },
	},
}

return LevelDialogue
