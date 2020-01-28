local extension = {}
local panel = nil
extension.name = "Dark Tauntscreen"
extension.is_enabled = true

function extension.OnTauntsRefreshed()
    if TAUNT.is_menu_open then
        extension.OnMenuClosed()
        extension.OnMenuOpened()
    end
end

function extension.OnMenuOpened()
    panel = vgui.Create("taunt_tauntscreen_dark")
end

function extension.OnMenuClosed()
    if IsValid(panel) then
        panel:Close()
        panel = nil
    end
end

function extension.OnEnable()
    if TAUNT.is_menu_open then
        extension.OnMenuOpened()
    end
end

function extension.OnDisable()
    extension.OnMenuClosed()
end

function extension.OnSuccess(taunt)
    panel:OnSuccess(taunt)
end

function extension.OnErrorInvalidPerms(taunt)
    panel:DisplayError("Error: You can't use " .. taunt.name .. " momentarily!")

end

function extension.OnErrorInvalidID(taunt)
    panel:DisplayError("Error: The taunt could not be found!")
end

function extension.OnErrorAlreadyTaunting(taunt)
    panel:DisplayError("Error: You are already taunting!")
end

hook.Add("TAUNT_Register_Extensions", "TAUNT_Register_Tauntscreen_Dark", function()
	TAUNT.RegisterExtension(extension)
end)
