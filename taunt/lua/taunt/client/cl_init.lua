TAUNT.menu = nil
TAUNT.extensions = {}
TAUNT.is_menu_open = false
TAUNT.current_taunt = nil
TAUNT.current_taunt_ends_at = 0

if not sql.TableExists("taunt_taunts") then
	sql.Query("CREATE TABLE taunt_taunts(id TEXT NOT NULL PRIMARY KEY, is_favorite INTEGER NOT NULL)")
end

if not sql.TableExists("taunt_extensions") then
	sql.Query("CREATE TABLE taunt_extensions(id TEXT NOT NULL PRIMARY KEY, is_enabled INTEGER NOT NULL)")
end 

hook.Add("Initialize", "TAUNT_GuiManager", function()
	TAUNT.ReloadExtensions()
end)
