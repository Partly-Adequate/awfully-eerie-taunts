net.Receive("TAUNT_Send_Taunts", function()
	print("Receiving Taunts")
	if IsValid(TAUNT.menu) then
		TAUNT.menu:Close()
	end

	local taunt_amount = net.ReadUInt(32)
	for index = 1, taunt_amount do
		local tauntinfo = {}
		tauntinfo.id = index
		tauntinfo.name = net.ReadString()
		tauntinfo.duration = net.ReadUInt(32)
		TAUNT.taunts[index] = tauntinfo
	end
end)
