function TAUNT.Taunt(ply, taunt_id)
    local taunt = TAUNT.taunts[taunt_id]
    PrintMessage(HUD_PRINTTALK, taunt.name)
    TAUNT.current_taunts_end_at[ply:SteamID()] = CurTime() + taunt.duration
end

function TAUNT.SendTaunts(ply)
    net.Start("TAUNT_Send_Taunts")
    net.WriteUInt(#(TAUNT.taunts), 32)
    for _,tauntinfo in ipairs(TAUNT.taunts) do
        net.WriteString(tauntinfo.name)
        net.WriteUInt(tauntinfo.duration, 32)
    end

    if IsValid(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end
