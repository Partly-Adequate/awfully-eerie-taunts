AET.menu = nil
AET.extensions = {}
AET.is_menu_open = false
AET.current_taunt = nil
AET.current_taunt_ends_at = 0

if not sql.TableExists("aet_taunts") then
	sql.Query("CREATE TABLE aet_taunts(id TEXT NOT NULL PRIMARY KEY, is_favorite INTEGER NOT NULL)")
end

if not sql.TableExists("aet_extensions") then
	sql.Query("CREATE TABLE aet_extensions(id TEXT NOT NULL PRIMARY KEY, is_enabled INTEGER NOT NULL)")
end 

hook.Add("Initialize", "AET_GuiManager", function()
	AET.ReloadExtensions()
end)
