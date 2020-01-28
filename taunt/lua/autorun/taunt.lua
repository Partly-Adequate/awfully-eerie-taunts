if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("taunt/sh_init.lua")

	AddCSLuaFile("taunt/client/cl_init.lua")
	AddCSLuaFile("taunt/client/cl_taunt.lua")
	AddCSLuaFile("taunt/client/cl_networking.lua")
	AddCSLuaFile("taunt/client/cl_commands.lua")
	AddCSLuaFile("taunt/client/cl_extension_manager.lua")
	AddCSLuaFile("taunt/client/cl_extension_handler.lua")

	AddCSLuaFile("taunt/client/extensions/cl_tauntscreen_dark.lua")
	AddCSLuaFile("taunt/client/extensions/cl_tauntscreen_dark_api.lua")
	
	include("taunt/sh_init.lua")
	include("taunt/server/sv_init.lua")
	include("taunt/server/sv_taunt.lua")
	include("taunt/server/sv_networking.lua")
else
	include("taunt/sh_init.lua")

	include("taunt/client/cl_init.lua")
	include("taunt/client/cl_taunt.lua")
	include("taunt/client/cl_networking.lua")
	include("taunt/client/cl_commands.lua")
	include("taunt/client/cl_extension_manager.lua")
	include("taunt/client/cl_extension_handler.lua")

	include("taunt/client/extensions/cl_tauntscreen_dark.lua")
	include("taunt/client/extensions/cl_tauntscreen_dark_api.lua")
end
