net.Receive("AET_Send_Taunts", function()
	local was_open = AET.CloseMenu()

	local taunt_amount = net.ReadUInt(32)
	for index = 1, taunt_amount do
		local tauntinfo = {}
		tauntinfo.id = index
		tauntinfo.name = net.ReadString()
		tauntinfo.duration = net.ReadUInt(32)
		AET.taunts[index] = tauntinfo
	end

	if was_open then
		AET.OpenMenu()
	end
end)

net.Receive("AET_Feedback", function()
	local feedback_type = net.ReadUInt(32)
	local taunt_id = net.ReadUInt(32)
	AET.InterpretFeedback(feedback_type, taunt_id)
end)

net.Receive("AET_Stop", function()
	AET.Stop()
end)
