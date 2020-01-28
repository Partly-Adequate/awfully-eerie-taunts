function TAUNT.Taunt(ply, taunt_id)
    local taunt = TAUNT.taunts[taunt_id]
    if not taunt.CanTaunt(ply) then return end
    taunt.Taunt()
    TAUNT.current_taunts_end_at[ply:SteamID()] = CurTime() + taunt.duration
end

function TAUNT.LoadTaunts()
    table.Empty(TAUNT.taunts)
    hook.Run("TAUNT_RegisterTaunts")
end

function TAUNT.RegisterTaunt(taunt)
    local id = #TAUNT.taunts + 1
    taunt.duration = taunt.duration or 0
    taunt.CanTaunt = taunt.CanTaunt or function(ply) return true end
    taunt.id = id
    TAUNT.taunts[id] = taunt
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
