function AET.Taunt(taunt)
	net.Start("AET_Taunt")
	net.WriteUInt(taunt.id, 32)
	net.SendToServer()
	AET.extension_handler.OnTauntAttempted()
end

function AET.Stop()
	AET.current_taunt_ends_at = 0
	AET.current_taunt = nil
end

function AET.ToggleVisibility()
	if AET.is_menu_open then
		AET.extension_handler.OnMenuClosed()
		AET.is_menu_open = false
	else
		AET.extension_handler.OnMenuOpened()
		AET.is_menu_open = true
	end
end

function AET.OpenMenu()
	if not AET.is_menu_open then
		AET.extension_handler.OnMenuOpened()
		AET.is_menu_open = true
	end
end

function AET.CloseMenu()
	if AET.is_menu_open then
		AET.extension_handler.OnMenuClosed()
		AET.is_menu_open = false
	end
end

function AET.IsFavorite(taunt)
	local data = sql.Query("SELECT is_favorite FROM aet_taunts WHERE id IS " .. sql.SQLStr(taunt.name))
	if data then
		--favorise taunt according to database
		if data[1]["is_favorite"] == "1" then
			return true;
		else
			return false;
		end
	end
	--insert new taunt into database
	sql.Query( "INSERT OR REPLACE INTO aet_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 0 .. ")")
	return false;
end

function AET.AddToFavorites(taunt)
	sql.Query( "INSERT OR REPLACE INTO aet_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 1 .. ")")
	AET.extension_handler.OnTauntAddedToFavorites(taunt)
end

function AET.RemoveFromFavorites(taunt)
	sql.Query( "INSERT OR REPLACE INTO aet_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 0 .. ")")
	AET.extension_handler.OnTauntRemovedFromFavorites(taunt)
end

function AET.InterpretFeedback(feedback_type, taunt_id)
	local taunt = AET.taunts[taunt_id]
	if feedback_type == AET.ERR_INVALID_PERMS then
		AET.extension_handler.OnErrorInvalidPerms(taunt)
		return
	end
	if feedback_type == AET.ERR_INVALID_ID then
		AET.extension_handler.OnErrorInvalidID(taunt)
		return
	end
	if feedback_type == AET.ERR_ALREADY_TAUNTING then
		AET.extension_handler.OnErrorAlreadyTaunting(taunt)
		return
	end
	if feedback_type == AET.SUCCESS then
		AET.current_taunt = taunt
		AET.current_taunt_ends_at = CurTime() + taunt.duration
		AET.extension_handler.OnSuccess(taunt)
		return
	end
end

function AET.ReloadExtensions()
	for _, extension in ipairs(AET.extensions) do
		AET.DisableExtension(extension)
	end
	table.Empty(AET.extensions)

	print("[AET] Registering extensions!")
	hook.Run("AET_Register_Extensions")
end

function AET.RegisterExtension(extension)
	local extension_id = #AET.extensions + 1
	extension.id = extension_id
	AET.extensions[extension_id] = extension
	print('[AET] Registering extension "' .. extension.name .. '"!')
	--check extension in database
	local data = sql.Query("SELECT is_enabled FROM aet_extensions WHERE name IS " .. sql.SQLStr(extension.name))
	if data then
		--enable/disable extension according to database
		if data[1]["is_enabled"] == "1" then
			extension.is_enabled = true;
		else
			extension.is_enabled = false;
		end
	else
		--insert new extension into database
		sql.Query( "INSERT OR REPLACE INTO aet_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. (extension.is_enabled and 1 or 0) .. ")")
	end
	--enable extension
	if extension.is_enabled then
		if extension.OnEnable then
			extension.OnEnable()
		end
	end
end

function AET.DisableExtension(extension)
	if not extension.is_enabled then return end
	extension.is_enabled = false
	if extension.OnDisable then
		extension.OnDisable()
	end
	sql.Query( "INSERT OR REPLACE INTO aet_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. 0 .. ")")
end

function AET.EnableExtension(extension)
	if extension.is_enabled then return end
	extension.is_enabled = true
	if extension.OnEnable then
		extension.OnEnable()
	end
	sql.Query( "INSERT OR REPLACE INTO aet_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. 1 .. ")")
end
