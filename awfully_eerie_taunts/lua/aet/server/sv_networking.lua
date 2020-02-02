net.Receive("AET_Taunt", function(len, ply)
    local taunt_id = net.ReadUInt(32)
    AET.Taunt(ply, taunt_id)
end)
