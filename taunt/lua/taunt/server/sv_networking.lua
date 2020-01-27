net.Receive("TAUNT_Taunt", function(len, ply)
    local taunt_id = net.ReadUInt(32)
    
    local current_taunt_ends_at = TAUNT.current_taunts_end_at[ply:SteamID()]
    if current_taunt_ends_at and current_taunt_ends_at > CurTime() then return end

    if not TAUNT.taunts[taunt_id] then return end

    TAUNT.Taunt(ply, taunt_id)    
end)
