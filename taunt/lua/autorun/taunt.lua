if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("taunt/sh_init.lua")

	AddCSLuaFile("taunt/client/cl_init.lua")
	AddCSLuaFile("taunt/client/cl_taunt.lua")
	AddCSLuaFile("taunt/client/cl_networking.lua")
	AddCSLuaFile("taunt/client/cl_taunt_menu.lua")
	AddCSLuaFile("taunt/client/cl_commands.lua")
	
	include("taunt/sh_init.lua")
	include("taunt/server/sv_init.lua")
	include("taunt/server/sv_taunt.lua")
	include("taunt/server/sv_networking.lua")
else
	include("taunt/sh_init.lua")

	include("taunt/client/cl_init.lua")
	include("taunt/client/cl_taunt_menu.lua")
	include("taunt/client/cl_taunt.lua")
	include("taunt/client/cl_networking.lua")
	include("taunt/client/cl_commands.lua")
end
