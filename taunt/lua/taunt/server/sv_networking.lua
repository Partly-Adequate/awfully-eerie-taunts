net.Receive("TAUNT_Taunt", function(len, ply)
    local taunt_id = net.ReadUInt(32)
    TAUNT.Taunt(ply, taunt_id)
end)
