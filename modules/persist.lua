----------------------------------------------------------------------
-- DEPENDENCIES
----------------------------------------------------------------------

local defsave = require "defsave.defsave"

----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local persist = {}

----------------------------------------------------------------------
-- CONSTANTS
----------------------------------------------------------------------

local default_data =
{
	settings =
	{
		music = 100,
		sound = 100,
		fullscreen = false
	},
	profile =
	{

	},
	world =
	{
		width = 3,
		height = 3,
		start_x = 2,
		start_y = 2,
		layout =
		{
			1, 1, 1,
			1, 1, 1,
			1, 1, 1
		}
	},
	levels =
	{
		{
			start_x = 7,
			start_y = 3
		}
	}
}

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function persist.init()
	defsave.set_appname("Tortellini Soup")
	defsave.default_data = default_data
	defsave.load("settings")
	defsave.load("profile")
	defsave.load("world")
	defsave.load("levels")
	defsave.save_all()
end

function persist.set_fullscreen(flag)
	defsave.set("settings", "fullscreen", flag)
	defsave.save("settings")
end

function persist.get_fullscreen()
	return defsave.get("settings", "fullscreen")
end

function persist.get_world()
	return
	{
		width = defsave.get("world", "width"),
		height = defsave.get("world", "height"),
		start_x = defsave.get("world", "start_x"),
		start_y = defsave.get("world", "start_y"),
		layout = defsave.get("world", "layout")
	}
end

function persist.get_level(id)
	return defsave.get("levels", id)
end

return persist