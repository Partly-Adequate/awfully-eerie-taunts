local CATEGORY_NAME = "TAUNT"

local function RefreshTaunts(calling_ply)
    TAUNT.LoadTaunts()
	TAUNT.SendTaunts()
    ulx.fancyLogAdmin(calling_ply, "#refreshed the taunts!")
end

local tauntrefreshcmd = ulx.command(CATEGORY_NAME, "taunt_refresh", RefreshTaunts, "!taunt_refresh")
tauntrefreshcmd:defaultAccess(ULib.ACCESS_ADMIN)
tauntrefreshcmd:help("refreshes the taunts")
