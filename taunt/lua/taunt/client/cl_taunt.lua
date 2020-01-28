function TAUNT.ToggleVisibility()
	if TAUNT.is_menu_open then
		TAUNT.extension_handler.OnMenuClosed()
		TAUNT.is_menu_open = false
	else
		TAUNT.extension_handler.OnMenuOpened()
		TAUNT.is_menu_open = true
	end
end

function TAUNT.OpenMenu()
	if not TAUNT.is_menu_open then
		TAUNT.extension_handler.OnMenuOpened()
		TAUNT.is_menu_open = true
	end
end

function TAUNT.CloseMenu()
	if TAUNT.is_menu_open then
		TAUNT.extension_handler.OnMenuClosed()
		TAUNT.is_menu_open = false
	end
end

function TAUNT.Taunt(taunt)
	net.Start("TAUNT_Taunt")
	net.WriteUInt(taunt.id, 32)
	net.SendToServer()
	TAUNT.extension_handler.OnTauntAttempted()
end

function TAUNT.IsFavorite(taunt)
	local data = sql.Query("SELECT is_favorite FROM taunt_taunts WHERE id IS " .. sql.SQLStr(taunt.name))
	if data then
		--favorise taunt according to database
		if data[1]["is_favorite"] == "1" then
			return true;
		else
			return false;
		end
	else
		--insert new taunt into database
		sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 0 .. ")")
	end
	return false;
end

function TAUNT.AddToFavorites(taunt)
	if not IsValid(taunt) or TAUNT.IsFavorite(taunt) then return end
	sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 1 .. ")")
	TAUNT.extension_handler.OnTauntAddedToFavorites(taunt)
end

function TAUNT.RemoveFromFavorites(taunt)
	if not IsValid(taunt) or not TAUNT.IsFavorite(taunt) then return end
	sql.Query( "INSERT OR REPLACE INTO taunt_taunts VALUES( " .. sql.SQLStr(taunt.name) .. ", " .. 0 .. ")")
	TAUNT.extension_handler.OnTauntRemovedFromFavorites(taunt)
end

function TAUNT.InterpretFeedback(feedback_type, taunt_id)
	local taunt = TAUNT.taunts[taunt_id]
	if feedback_type == TAUNT.ERR_INVALID_PERMS then
		TAUNT.extension_handler.OnErrorInvalidPerms(taunt)
		return
	end
	if feedback_type == TAUNT.ERR_INVALID_ID then
		TAUNT.extension_handler.OnErrorInvalidID(taunt)
		return
	end
	if feedback_type == TAUNT.ERR_ALREADY_TAUNTING then
		TAUNT.extension_handler.OnErrorAlreadyTaunting(taunt)
		return
	end
	if feedback_type == TAUNT.SUCCESS then
		TAUNT.extension_handler.OnSuccess(taunt)
		return
	end
end

function TAUNT.ReloadExtensions()
	for _, extension in ipairs(TAUNT.extensions) do
		TAUNT.DisableExtension(extension)
	end
	table.Empty(TAUNT.extensions)

	print("[TAUNT] Registering extensions!")
	hook.Run("TAUNT_Register_Extensions")
end

function TAUNT.RegisterExtension(extension)
	local extension_id = #TAUNT.extensions + 1
	extension.id = extension_id
	TAUNT.extensions[extension_id] = extension
	print('[TAUNT] Registering extension "' .. extension.name .. '"!')
	--check extension in database
	local data = sql.Query("SELECT is_enabled FROM pam_extensions WHERE name IS " .. sql.SQLStr(extension.name))
	if data then
		--enable/disable extension according to database
		if data[1]["is_enabled"] == "1" then
			extension.is_enabled = true;
		else
			extension.is_enabled = false;
		end
	else
		--insert new extension into database
		sql.Query( "INSERT OR REPLACE INTO taunt_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. (extension.is_enabled and 1 or 0) .. ")")
	end
	--enable extension
	if extension.is_enabled then
		if extension.OnEnable then
			extension.OnEnable()
		end
	end
end

function TAUNT.DisableExtension(extension)
	if not extension.is_enabled then return end
	extension.is_enabled = false
	if extension.OnDisable then
		extension.OnDisable()
	end
	sql.Query( "INSERT OR REPLACE INTO taunt_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. 0 .. ")")
end

function TAUNT.EnableExtension(extension)
	if extension.is_enabled then return end
	extension.is_enabled = true
	if extension.OnEnable then
		extension.OnEnable()
	end
	sql.Query( "INSERT OR REPLACE INTO taunt_extensions VALUES( " .. sql.SQLStr(extension.name) .. ", " .. 1 .. ")")
end
