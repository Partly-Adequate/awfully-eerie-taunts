local CATEGORY_NAME = "AET"

local function RefreshTaunts(calling_ply)
    AET.LoadTaunts()
	AET.SendTaunts()
    ulx.fancyLogAdmin(calling_ply, "#A refreshed the taunts!")
end

local tauntrefreshcmd = ulx.command(CATEGORY_NAME, "taunt_refresh", RefreshTaunts, "!taunt_refresh")
tauntrefreshcmd:defaultAccess(ULib.ACCESS_ADMIN)
tauntrefreshcmd:help("refreshes the taunts")
