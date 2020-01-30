function TAUNT.Taunt(ply, taunt_id)
    local current_taunt_ends_at = TAUNT.current_taunts_end_at[ply:SteamID()] or 0
    
    if current_taunt_ends_at > CurTime() then
        net.Start("TAUNT_Feedback")
        net.WriteUInt(TAUNT.ERR_ALREADY_TAUNTING, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end
    
    local taunt = TAUNT.taunts[taunt_id]
    
    if not taunt then
        net.Start("TAUNT_Feedback")
        net.WriteUInt(TAUNT.ERR_INVALID_ID, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end

    if not taunt.CanTaunt(ply) then
        net.Start("TAUNT_Feedback")
        net.WriteUInt(TAUNT.ERR_INVALID_PERMS, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end

    taunt.Taunt(ply)
    TAUNT.current_taunts_end_at[ply:SteamID()] = CurTime() + taunt.duration
    net.Start("TAUNT_Feedback")
    net.WriteUInt(TAUNT.SUCCESS, 32)
    net.WriteUInt(taunt_id, 32)
    net.Send(ply)
end

function TAUNT.LoadTaunts()
    table.Empty(TAUNT.taunts)
    print("[TAUNT] Registering taunts!")
    hook.Run("TAUNT_RegisterTaunts")
end

function TAUNT.RegisterTaunt(taunt)
    local id = #TAUNT.taunts + 1
    taunt.duration = taunt.duration or 0
    taunt.CanTaunt = taunt.CanTaunt or function(ply) return true end
    taunt.id = id
    TAUNT.taunts[id] = taunt
    print("[TAUNT] Registered " .. taunt.name .. " with id " .. id .. "!")
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
