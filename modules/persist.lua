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

	}
}

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function persist.init()
	defsave.set_appname("Template Defold Game")
	defsave.default_data = default_data
	defsave.enable_obfuscation = true
	defsave.obfuscation_key = "obfuscation_key"
	defsave.load("settings")
	defsave.load("profile")
end

function persist.set_fullscreen(flag)
	defsave.set("settings", "fullscreen", flag)
	defsave.save("settings")
end

function persist.get_fullscreen()
	return defsave.get("settings", "fullscreen")
end

return persist