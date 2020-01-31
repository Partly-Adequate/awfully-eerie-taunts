--path for taunts inside the sound folder
local path = "taunt/ttt/"

--get all sound files
local taunt_files = file.Find("sound/" .. path .. "*.wav", "GAME")
if taunt_files then
    for i,taunt_file in ipairs(taunt_files) do
        --add sound structures for easier access
        sound.Add({
            name = taunt_file:sub(1, -5),
            channel = CHAN_VOICE,
            volume = 1.0,
            level = 120,
            pitch = {100, 100},
            sound = path .. taunt_file
        })

        --send sounds to clients
        resource.AddFile("sound/" .. path .. taunt_file)
    end
end

--registers all taunts
local function RegisterTaunts()
    -- only register taunts when the gamemode is ttt
    if GAMEMODE_NAME != "terrortown" then return end
    if not taunt_files then return end

    for _,taunt_file in ipairs(taunt_files) do
        --create taunt structure
        local taunt = {
            name = taunt_file:sub(1, -5),
            duration = SoundDuration(path .. taunt_file)
        }
        taunt.CanTaunt = function(ply)
            return ply:IsTerror()
        end
        taunt.Taunt = function(ply)
            ply:EmitSound(taunt.name)
        end
        taunt.StopTaunt = function(ply)
            ply:StopSound(taunt.name)
        end

        --register taunt
        TAUNT.RegisterTaunt(taunt)
    end
end

hook.Add("TAUNT_RegisterTaunts", "TAUNT_RegisterTTTTaunts", RegisterTaunts)
