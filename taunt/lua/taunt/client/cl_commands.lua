--toggle menu visibility
concommand.Add("taunt_toggle_menu", function(player, cmd, args, arg_str)
    TAUNT.ToggleVisibility()
end)

--create a menu selection screen
concommand.Add("taunt_extension_manager", function(player, cmd, args, arg_str)
	if IsValid(PAM.extension_manager) then
		PAM.extension_manager:Remove()
	else
		PAM.extension_manager = vgui.Create("taunt_extension_manager")
	end
end)

--registers commands for the ttt2 bind menu
hook.Add("Initialize", "TauntBindings", function()
	if TTT2 then
		bind.Register("taunt_toggle_menu", function()
			LocalPlayer():ConCommand("taunt_toggle_menu")
		end, nil, "TAUNT", "Toggle menu visibility", nil)

		bind.Register("taunt_extension_manager", function()
			LocalPlayer():ConCommand("taunt_extension_manager")
		end, nil, "TAUNT", "Extension Manager", nil)
	end
end)
