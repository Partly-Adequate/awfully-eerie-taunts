--the taunt table
local taunt_example = {}

--the name of the taunt (this is mandatory and should be unique)
taunt_example.name = "Hello World"
--the duration of the taunt
taunt_example.duration = 3

--gets called to determine if the given player is able to taunt
taunt_example.CanTaunt = function(ply)
    return true
end

--gets called once this taunt is used
taunt_example.Taunt = function()
    print("Hello World")
end

--hook to register taunts
hook.Add("TAUNT_RegisterTaunts", "TAUNT_RegisterExampleTaunt", function()
    --registers the taunt
    TAUNT.RegisterTaunt(taunt_example)
end)
