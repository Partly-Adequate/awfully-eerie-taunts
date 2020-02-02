--toggle menu visibility
concommand.Add("aet_toggle_menu", function(player, cmd, args, arg_str)
    AET.ToggleVisibility()
end)

--create a menu selection screen
concommand.Add("aet_extension_manager", function(player, cmd, args, arg_str)
	if IsValid(AET.extension_manager) then
		AET.extension_manager:Remove()
	else
		AET.extension_manager = vgui.Create("aet_extension_manager")
	end
end)

--registers commands for the ttt2 bind menu
hook.Add("Initialize", "AET_Bindings", function()
	if TTT2 then
		bind.Register("aet_toggle_menu", function()
			LocalPlayer():ConCommand("aet_toggle_menu")
		end, nil, "Awfully Eerie Taunts", "Toggle menu visibility", nil)

		bind.Register("aet_extension_manager", function()
			LocalPlayer():ConCommand("aet_extension_manager")
		end, nil, "Awfully Eerie Taunts", "Extension Manager", nil)
	end
end)
