--server->all
util.AddNetworkString("TAUNT_Send_Taunts")
--client->server
util.AddNetworkString("TAUNT_Taunt")

--add resources
resource.AddFile("materials/vgui/taunt_ic_fav.vmt")
resource.AddFile("materials/vgui/taunt_ic_nofav.vmt")

TAUNT.current_taunts_end_at = {}
TAUNT.taunts = {
    {
        id = 1,
        name = "ab",
        duration = 10
    },
    {
        id = 2,
        name = "bc",
        duration = 5
    },
    {
        id = 3,
        name = "cd",
        duration = 20
    },
    {
        id = 4,
        name = "da",
        duration = 1
    }
}

hook.Add("PlayerInitialSpawn", "TAUNT_PlayerSpawned", function(ply, transition)
    TAUNT.SendTaunts(ply)
end)
