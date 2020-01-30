--path for taunts inside the sound folder
local path = "taunt/ttt/"

--get all sound files
local taunt_files = file.Find("sound/" .. path .. "*.wav", "GAME")

for i,taunt_file in ipairs(taunt_files) do
    print(taunt_file)
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

--registers all taunts
local function RegisterTaunts()
    if GAMEMODE_NAME != "terrortown" then return end
    
    print("Registering ttttaunts!")
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
        
        --register taunt
        TAUNT.RegisterTaunt(taunt)
    end
end

hook.Add("TAUNT_RegisterTaunts", "TAUNT_RegisterTTTTaunts", RegisterTaunts)
