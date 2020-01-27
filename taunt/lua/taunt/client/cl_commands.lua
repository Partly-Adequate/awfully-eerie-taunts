--toggle menu visibility
concommand.Add("taunt_toggle_menu", function(player, cmd, args, arg_str)
    TAUNT.ToggleVisibility()
end)

--registers commands for the ttt2 bind menu
hook.Add("Initialize", "TauntBindings", function()
	if TTT2 then
		bind.Register("taunt_toggle_menu", function()
			LocalPlayer():ConCommand("taunt_toggle_menu")
		end, nil, "Totally Nervewrecking Unnecassary Acustic Taunts", "Toggle menu visibility", nil)
	end
end)
