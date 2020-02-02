--server->all
util.AddNetworkString("AET_Send_Taunts")
--client->server
util.AddNetworkString("AET_Taunt")
--server->client
util.AddNetworkString("AET_Stop")
--server->client
util.AddNetworkString("AET_Feedback")

--add resources
resource.AddFile("materials/vgui/aet/ic_favorite.vmt")
resource.AddFile("materials/vgui/aet/ic_not_favorite.vmt")
resource.AddFile("materials/vgui/aet/ic_selected.vmt")
resource.AddFile("materials/vgui/aet/ic_not_selected.vmt")

AET.current_taunts = {}
AET.current_taunts_end_at = {}
AET.taunts = {}

hook.Add("PlayerInitialSpawn", "AET_PlayerSpawned", function(ply, transition)
    AET.SendTaunts(ply)
end)

hook.Add("Initialize", "AET_RegisterTaunts", function()
    AET.LoadTaunts()
end)

hook.Add("PostPlayerDeath", "AET_RegisterDeaths", function(ply)
    AET.StopTaunt(ply)
end)
