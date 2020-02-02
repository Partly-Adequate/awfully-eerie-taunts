local PANEL = {}

-- alignment helping values
local taunt_button_height = 20
local scroll_bar_size = 14
local settings_height = 25

-- colors
local col_base = {r = 40, g = 40, b = 40, a = 255}
local col_base_darker = {r = 30, g = 30, b = 30, a = 255}
local col_base_darkest = {r = 20, g = 20, b = 20, a = 255}
local col_text = {r = 150, g = 150, b = 150, a = 255}
local col_text_error = {r = 250, g = 50, b = 50, a = 255}

-- images and icons
local ic_favorite = Material("vgui/aet/ic_favorite")
local ic_not_favorite = Material("vgui/aet/ic_not_favorite")

surface.CreateFont("AET_ButtonFont", {
	font = "Trebuchet MS",
	size = taunt_button_height * 0.75
})

surface.CreateFont("AET_CountdownFont", {
	font = "Trebuchet MS",
	size = settings_height * 0.95
})

surface.CreateFont("AET_SettingsFont", {
	font = "Trebuchet MS",
	size = settings_height * 0.75
})

function PANEL:Init()
	local width = ScrW() * 0.3
	local height = ScrH() * 0.75
	self:SetSize(width, height)
	self:SetPos((ScrW() - width) * 0.5, (ScrH() - height) * 0.5)
	self:SetZPos(-100)
	self:SetTitle("Awfully Eerie Taunts")
	
	self.OnClose = function()
		AET.CloseMenu()
	end

	self.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, 25)
		surface.SetDrawColor(col_base)
		surface.DrawRect(0, 25, w, h - 25)
	end

	self.search_term = ""
	self.show_favorites = false
	self.taunt_buttons = {}
	self.current_taunt_ends_at = 0
	self.lbl_error = nil

	local container = vgui.Create("DPanel", self)
	container:SetSize(width, height - 25)
	container:SetPos(0, 25)
	container.Paint = function(s, w, h) end

	self:InitSettings(container, 0, 0, width, settings_height * 2)
	self:InitTauntList(container, 0, settings_height * 2, width, height - settings_height * 3)
	self:InitError(container, 0, height - settings_height * 2, width, settings_height)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
end

function PANEL:InitSettings(parent, pos_x, pos_y, width, height)
	local pnl_vote_settings = vgui.Create("Panel", parent)
	pnl_vote_settings:SetSize(width, height)
	pnl_vote_settings:SetPos(pos_x, pos_y)
	pnl_vote_settings.Paint = function(s, w, h) end

    local settings_width = (width - settings_height) / 2

	self:InitCountDown(pnl_vote_settings, 0, 0, width, settings_height)
	self:InitSearchArea(pnl_vote_settings, 0, settings_height, settings_width, settings_height)
	self:InitSortBox(pnl_vote_settings, settings_width, settings_height, settings_width, settings_height)
	self:InitFavorites(pnl_vote_settings, settings_width * 2, settings_height, settings_height, settings_height)
end

function PANEL:InitCountDown(parent, pos_x, pos_y, width, height)
	local lbl_countdown = vgui.Create("DLabel", parent)
	lbl_countdown:SetSize(width, height)
	lbl_countdown:SetPos(pos_x, pos_y)
	lbl_countdown:SetTextColor(col_text)
	lbl_countdown:SetFont("AET_CountdownFont")
	lbl_countdown:SetContentAlignment(5)
	lbl_countdown.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base)
		surface.DrawRect(2, 2, w - 4, h - 4)
	end
	lbl_countdown.Think = function()
		local time_left = math.Round(math.max(AET.current_taunt_ends_at - CurTime(), 0))
		if time_left > 0 then
			local minutes = math.floor(time_left / 60)
			local seconds = time_left % 60
			lbl_countdown:SetText(minutes .. ":" .. ((seconds < 10) and ("0" .. seconds) or seconds) .. " seconds left!") 
		else
			lbl_countdown:SetText("Taunt is ready!")
		end
	end
end

function PANEL:InitSearchArea(parent, pos_x, pos_y, width, height)
	local pnl_container = vgui.Create("DPanel", parent)
	pnl_container:SetSize(width, height)
	pnl_container:SetPos(pos_x, pos_y)
	pnl_container.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base)
		surface.DrawRect(2, 2, w - 4, h - 4)
	end
	
	local txt_search = vgui.Create("DTextEntry", pnl_container)
	txt_search:SetPlaceholderText("Search for taunts...")
	txt_search:SetSize(width, height)
	txt_search:SetPos(0, 0)
	txt_search:SetPaintBackground(false)
	txt_search:SetFont("AET_SettingsFont")
	txt_search:SetTextColor(col_text)
	txt_search:SetCursorColor(col_text)
	txt_search:SetPlaceholderColor(col_text)
	
	txt_search.OnChange = function()
		self.search_term = txt_search:GetValue()
		self:RefreshTauntList()
	end
	txt_search.OnGetFocus = function()
		self:SetKeyboardInputEnabled(true)
	end
	txt_search.OnLoseFocus = function()
		self:SetKeyboardInputEnabled(false)
	end
end

function PANEL:InitSortBox(parent, pos_x, pos_y, width, height)
	local function CompareStrings(string_1, string_2)
		string_1 = string.lower(string_1)
		string_2 = string.lower(string_2)

		for i = 1, math.min(#string_1, #string_2) do
			byte_1 = string.byte(string_1:sub(i, i))
			byte_2 = string.byte(string_2:sub(i, i))
			if byte_1 < byte_2 then
				return true
			elseif byte_1 > byte_2 then
				return false
			end
		end
		return #string_1 < #string_2
	end

	local cb_sort_by = vgui.Create("DComboBox", parent)
	cb_sort_by:SetValue("Sort by...")
	cb_sort_by:SetPos(pos_x, pos_y)
	cb_sort_by:SetSize(width, height)
	cb_sort_by.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base)
		surface.DrawRect(2, 2, w - 4, h - 4)
	end
	cb_sort_by:SetTextColor(col_text)
	cb_sort_by:SetFont("AET_SettingsFont")

	cb_sort_by:AddChoice("Name [a-z]", function(taunt_button_1, taunt_button_2)
		return CompareStrings(taunt_button_1.taunt.name, taunt_button_2.taunt.name)
	end)
	cb_sort_by:AddChoice("Name [z-a]", function(taunt_button_1, taunt_button_2)
		return not CompareStrings(taunt_button_1.taunt.name, taunt_button_2.taunt.name)
	end)
	cb_sort_by:AddChoice("shortest duration", function(taunt_button_1, taunt_button_2)
		if not taunt_button_1 or not taunt_button_2 then
			return true
		end
		return taunt_button_1.taunt.duration < taunt_button_2.taunt.duration
	end)
	cb_sort_by:AddChoice("longest duration", function(taunt_button_1, taunt_button_2)
		if not taunt_button_1 or not taunt_button_2 then
			return true
		end
		return taunt_button_1.taunt.duration > taunt_button_2.taunt.duration
	end)

	cb_sort_by.OnSelect = function(cb, index, text)
		local _, comparator = cb:GetSelected()
		self:SortTauntList(comparator)
	end
end

function PANEL:InitFavorites(parent, pos_x, pos_y, width, height)
	local btn_toggle_favorites = vgui.Create("DButton", parent)
	btn_toggle_favorites:SetSize(width, height)
	btn_toggle_favorites:SetPos(pos_x, pos_y)
	btn_toggle_favorites:SetTextColor(col_text)
	btn_toggle_favorites:SetText("")
	btn_toggle_favorites.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base)
		surface.DrawRect(2, 2, w - 4, h - 4)
	end

	local icon = vgui.Create("DImage", btn_toggle_favorites)
	icon:SetPos(0, 0)
	icon:SetSize(settings_height, settings_height)
	icon:SetMaterial(ic_not_favorite)

	btn_toggle_favorites.DoClick = function()
		self.show_favorites = not self.show_favorites
		if self.show_favorites then
			icon:SetMaterial(ic_favorite)
		else
			icon:SetMaterial(ic_not_favorite)
		end
		self:RefreshTauntList()
	end
end

function PANEL:InitTauntList(parent, pos_x, pos_y, width, height)
	local pnl_container = vgui.Create("DPanel", parent)
	pnl_container:SetSize(width, height)
	pnl_container:SetPos(pos_x, pos_y)

	pnl_container.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darker)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(w - scroll_bar_size, 0, scroll_bar_size, h)
	end

	self.taunt_list = vgui.Create("DPanelList", pnl_container)
	self.taunt_list:SetSize(width, height)
	self.taunt_list:SetPos(0, 0)
	self.taunt_list:EnableHorizontal(false)
	self.taunt_list:EnableVerticalScrollbar()
	self:InitTauntButtons(width - scroll_bar_size)
	self:RefreshTauntList()
end

function PANEL:InitError(parent, pos_x, pos_y, width, height)
	local lbl_error = vgui.Create("DLabel", parent)
	lbl_error:SetSize(width, height)
	lbl_error:SetPos(pos_x, pos_y)
	lbl_error:SetTextColor(col_text_error)
	lbl_error:SetFont("AET_SettingsFont")
	lbl_error:SetText("")
	lbl_error:SetContentAlignment(5)
	lbl_error.Paint = function(s, w, h)
		surface.SetDrawColor(col_base_darkest)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col_base)
		surface.DrawRect(2, 2, w - 4, h - 4)
	end
	self.lbl_error = lbl_error
end

function PANEL:FitsSearchTerm(button)
	local search_term = self.search_term

	if not search_term or search_term == "" then return true end
	if #search_term > #button.taunt.name then return false end

	local i = 1
	for j = 1, #button.taunt.name do
		if button.taunt.name:sub(j, j):lower() == search_term:sub(i, i):lower() then
			if i >= #search_term then
				return true
			end
			i = i + 1
		end
	end

	return false
end

function PANEL:SortTauntList(comparator)
	table.sort(self.taunt_buttons, comparator)
	self:RefreshTauntList()
end

function PANEL:RefreshTauntList()
	self.taunt_list:Clear()
	for _, taunt_button in pairs(self.taunt_buttons) do
		if self:FitsSearchTerm(taunt_button) and (not self.show_favorites or AET.IsFavorite(taunt_button.taunt)) then
			self.taunt_list:AddItem(taunt_button)
			taunt_button:SetVisible(true)
		else
			taunt_button:SetVisible(false)
		end
	end
end

function PANEL:InitTauntButtons(taunt_button_width)
    local taunt_button_name_width = (taunt_button_width - taunt_button_height) * 0.8
    local taunt_button_duration_width = (taunt_button_width - taunt_button_name_width - taunt_button_height)
	for k, tauntinfo in pairs(AET.taunts) do
		local taunt_button = vgui.Create("DButton")
		taunt_button:SetSize(taunt_button_width, taunt_button_height)
		taunt_button:SetText("")
		taunt_button:SetPaintBackground(false)
		taunt_button.voter_count = 0
		taunt_button.taunt = tauntinfo
		taunt_button.DoClick = function()
			AET.Taunt(taunt_button.taunt)
		end

		-- name label
		local lbl_name = vgui.Create("DLabel", taunt_button)
		lbl_name:SetPos(0, 0)
		lbl_name:SetSize(taunt_button_name_width, taunt_button_height)
		lbl_name:SetContentAlignment(4)
		lbl_name:SetText(tauntinfo.name)
		lbl_name:SetTextColor(col_text)
		lbl_name:SetFont("AET_ButtonFont")

		-- duration label
		local lbl_duration = vgui.Create("DLabel", taunt_button)
		lbl_duration:SetPos(taunt_button_name_width, 0)
		lbl_duration:SetSize(taunt_button_duration_width, taunt_button_height)
		lbl_duration:SetContentAlignment(5)
		lbl_duration:SetTextColor(col_text)
		lbl_duration:SetFont("AET_ButtonFont")
		
        local minutes = math.floor(tauntinfo.duration / 60)
        local seconds = tauntinfo.duration % 60
        lbl_duration:SetText(minutes .. ":" .. ((seconds < 10) and ("0" .. seconds) or seconds))

		-- heart for favorites
		local ibtn_favorite = vgui.Create("DImageButton", taunt_button)
		if AET.IsFavorite(tauntinfo) then
			ibtn_favorite:SetMaterial(ic_favorite)
		else
			ibtn_favorite:SetMaterial(ic_not_favorite)
		end
		ibtn_favorite:SetPos(taunt_button_name_width + taunt_button_duration_width, 0)
		ibtn_favorite:SetSize(taunt_button_height, taunt_button_height)
		ibtn_favorite.DoClick = function()
			if AET.IsFavorite(taunt_button.taunt) then
				AET.RemoveFromFavorites(taunt_button.taunt)
				ibtn_favorite:SetMaterial(ic_not_favorite)
			else
				AET.AddToFavorites(taunt_button.taunt)
				ibtn_favorite:SetMaterial(ic_favorite)
			end
			self:RefreshTauntList()
		end

		-- override default texture
		taunt_button.Paint = function(s, w, h)
			surface.SetDrawColor(col_base)
			surface.DrawRect(0, 0, taunt_button_name_width, taunt_button_height)
			surface.SetDrawColor(col_base_darkest)
			surface.DrawRect(taunt_button_name_width, 0, taunt_button_duration_width + taunt_button_height, taunt_button_height);
			surface.DrawOutlinedRect(0, 0, taunt_button_name_width, taunt_button_height)
		end

		table.insert(self.taunt_buttons, taunt_button)
	end
end

function PANEL:OnSuccess(taunt)
	self.current_taunt_ends_at = CurTime() + taunt.duration
	self.lbl_error:SetText("")
end

function PANEL:DisplayError(error)
	self.lbl_error:SetText(error)
end

derma.DefineControl("aet_tauntscreen_dark", "", PANEL, "DFrame")
