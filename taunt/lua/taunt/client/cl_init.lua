TAUNT.menu = nil
TAUNT.current_taunt_ends_at = 0

if not sql.TableExists("taunt_taunts") then
	sql.Query("CREATE TABLE taunt_taunts(id TEXT NOT NULL PRIMARY KEY, is_favorite INTEGER NOT NULL)")
end
