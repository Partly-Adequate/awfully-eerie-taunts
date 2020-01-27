local function OpenMenu()
	TAUNT.menu = vgui.Create("taunt_tauntscreen_dark")
end

local function CloseMenu()
	TAUNT.menu:Close()
end

function TAUNT.ToggleVisibility()
	if IsValid(TAUNT.menu) then
		CloseMenu()
	else
    	OpenMenu()
	end
end

function TAUNT.OpenMenu()
	if IsValid(TAUNT.menu) then return false end
	OpenMenu()
	return true
end

function TAUNT.CloseMenu()
	if not IsValid(TAUNT.menu) then return false end
	CloseMenu()
	return true
end

function TAUNT.Taunt(taunt)
	if TAUNT.current_taunt_ends_at > CurTime() then return end
	net.Start("TAUNT_Taunt")
	net.WriteUInt(taunt.id, 32)
	net.SendToServer()
	TAUNT.current_taunt_ends_at = CurTime() + taunt.duration
end

function TAUNT.IsFavorite(tauntname)
	local data = sql.Query("SELECT is_favorite FROM taunt_taunts WHERE id IS " .. sql.SQLStr(tauntname))
	if data then
		--favorise taunt according to database
		if data[1]["is_favorite"] == "1" then
			return true;
		else
			return false;
		end
	else
		--insert new taunt into database
		sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(tauntname) .. ", " .. 0 .. ")")
	end
	return false;
end

function TAUNT.AddToFavorites(tauntname)
	if TAUNT.IsFavorite(tauntname) then return end
	sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(tauntname) .. ", " .. 1 .. ")")
end

function TAUNT.RemoveFromFavorites(tauntname)
	if not TAUNT.IsFavorite(tauntname) then return end
	sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(tauntname) .. ", " .. 0 .. ")")
end
