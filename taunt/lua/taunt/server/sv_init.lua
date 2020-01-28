--server->all
util.AddNetworkString("TAUNT_Send_Taunts")
--client->server
util.AddNetworkString("TAUNT_Taunt")
--server->client
util.AddNetworkString("TAUNT_Feedback")

--add resources
resource.AddFile("materials/vgui/taunt/ic_favorite.vmt")
resource.AddFile("materials/vgui/taunt/ic_not_favorite.vmt")
resource.AddFile("materials/vgui/taunt/ic_selected.vmt")
resource.AddFile("materials/vgui/taunt/ic_not_selected.vmt")

TAUNT.current_taunts_end_at = {}
TAUNT.taunts = {}

hook.Add("PlayerInitialSpawn", "TAUNT_PlayerSpawned", function(ply, transition)
    TAUNT.SendTaunts(ply)
end)

hook.Add("Initialize", "TAUNT_RegisterTaunts", function()
    TAUNT.LoadTaunts()
end)
