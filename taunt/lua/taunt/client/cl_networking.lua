net.Receive("TAUNT_Send_Taunts", function()
	local was_open = TAUNT.CloseMenu()

	local taunt_amount = net.ReadUInt(32)
	for index = 1, taunt_amount do
		local tauntinfo = {}
		tauntinfo.id = index
		tauntinfo.name = net.ReadString()
		tauntinfo.duration = net.ReadUInt(32)
		TAUNT.taunts[index] = tauntinfo
	end

	if was_open then
		TAUNT.OpenMenu()
	end
end)

net.Receive("TAUNT_Feedback", function()
	local feedback_type = net.ReadUInt(32)
	local taunt_id = net.ReadUInt(32)
	TAUNT.InterpretFeedback(feedback_type, taunt_id)
end)

net.Receive("TAUNT_Stop", function()
	TAUNT.Stop()
end)
