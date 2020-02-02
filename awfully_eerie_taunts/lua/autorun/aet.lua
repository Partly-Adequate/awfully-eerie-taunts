if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("aet/sh_init.lua")

	AddCSLuaFile("aet/client/cl_init.lua")
	AddCSLuaFile("aet/client/cl_aet.lua")
	AddCSLuaFile("aet/client/cl_networking.lua")
	AddCSLuaFile("aet/client/cl_commands.lua")
	AddCSLuaFile("aet/client/cl_extension_manager.lua")
	AddCSLuaFile("aet/client/cl_extension_handler.lua")

	AddCSLuaFile("aet/client/extensions/cl_tauntscreen_dark.lua")
	AddCSLuaFile("aet/client/extensions/cl_tauntscreen_dark_api.lua")
	
	include("aet/sh_init.lua")
	include("aet/server/sv_init.lua")
	include("aet/server/sv_aet.lua")
	include("aet/server/sv_networking.lua")
else
	include("aet/sh_init.lua")

	include("aet/client/cl_init.lua")
	include("aet/client/cl_aet.lua")
	include("aet/client/cl_networking.lua")
	include("aet/client/cl_commands.lua")
	include("aet/client/cl_extension_manager.lua")
	include("aet/client/cl_extension_handler.lua")

	include("aet/client/extensions/cl_tauntscreen_dark.lua")
	include("aet/client/extensions/cl_tauntscreen_dark_api.lua")
end
