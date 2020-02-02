function AET.Taunt(ply, taunt_id)
    local current_taunt_ends_at = AET.current_taunts_end_at[ply:SteamID()] or 0
    
    if current_taunt_ends_at > CurTime() then
        net.Start("AET_Feedback")
        net.WriteUInt(AET.ERR_ALREADY_TAUNTING, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end
    
    local taunt = AET.taunts[taunt_id]
    
    if not taunt then
        net.Start("AET_Feedback")
        net.WriteUInt(AET.ERR_INVALID_ID, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end

    if not taunt.CanTaunt(ply) then
        net.Start("AET_Feedback")
        net.WriteUInt(AET.ERR_INVALID_PERMS, 32)
        net.WriteUInt(taunt_id, 32)
        net.Send(ply)
        return
    end

    taunt.Taunt(ply)
    AET.current_taunts_end_at[ply:SteamID()] = CurTime() + taunt.duration
    AET.current_taunts[ply:SteamID()] = taunt
    net.Start("AET_Feedback")
    net.WriteUInt(AET.SUCCESS, 32)
    net.WriteUInt(taunt_id, 32)
    net.Send(ply)
end

function AET.StopTaunt(ply)
    if not IsValid(ply) then return end
    
    local current_taunt_ends_at = AET.current_taunts_end_at[ply:SteamID()] or 0
    if current_taunt_ends_at < CurTime() then return end

    local current_taunt = AET.current_taunts[ply:SteamID()]
    current_taunt.StopTaunt(ply)
    AET.current_taunts_end_at[ply:SteamID()] = 0
    AET.current_taunts[ply:SteamID()] = nil
    net.Start("AET_Stop")
    net.Send(ply)
    return
end

function AET.LoadTaunts()
    table.Empty(AET.taunts)
    print("[AET] Registering taunts!")
    hook.Run("AET_RegisterTaunts")
end

function AET.RegisterTaunt(taunt)
    local id = #AET.taunts + 1
    taunt.duration = taunt.duration or 0
    taunt.CanTaunt = taunt.CanTaunt or function(ply) return true end
    taunt.StopTaunt = taunt.StopTaunt or function(ply) end
    taunt.id = id
    AET.taunts[id] = taunt
    print("[AET] Registered " .. taunt.name .. " with id " .. id .. "!")
end

function AET.SendTaunts(ply)
    net.Start("AET_Send_Taunts")
    net.WriteUInt(#(AET.taunts), 32)
    for _,tauntinfo in ipairs(AET.taunts) do
        net.WriteString(tauntinfo.name)
        net.WriteUInt(tauntinfo.duration, 32)
    end

    if IsValid(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end
