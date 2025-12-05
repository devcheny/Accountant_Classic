--[[
$Id: AccountantOptions.lua 17 2009-06-06 14:07:52Z arith $
]]
if not ACCOUNTANT_OPTIONS_TITLE then
	ACCOUNTANT_OPTIONS_TITLE = "Opciones de Accountant";
end

function AccountantOptions_Toggle()
	if(AccountantOptionsFrame:IsVisible()) then
		AccountantOptionsFrame:Hide();
	else
		AccountantOptionsFrame:Show();
	end
end

function AccountantOptions_OnLoad()
	UIPanelWindows['AccountantOptionsFrame'] = {area = 'center', pushable = 0};
end

function AccountantOptions_OnShow()
	-- Fallbacks locales por si ACCLOC_* está nil
	local L_MINIBUT   = ACCLOC_MINIBUT   or "Mostrar botón del minimapa";
	local L_BUTPOS    = ACCLOC_BUTPOS    or "Posición del botón del minimapa";
	local L_STARTWEEK = ACCLOC_STARTWEEK or "Inicio de la semana";
	local L_WD = {
		ACCLOC_WD_SUN or "Domingo",
		ACCLOC_WD_MON or "Lunes",
		ACCLOC_WD_TUE or "Martes",
		ACCLOC_WD_WED or "Miércoles",
		ACCLOC_WD_THU or "Jueves",
		ACCLOC_WD_FRI or "Viernes",
		ACCLOC_WD_SAT or "Sábado",
	}

	-- Cabecera
	if AccountantOptionsFrameHeaderText then
		AccountantOptionsFrameHeaderText:SetText(ACCOUNTANT_OPTIONS_TITLE or "Opciones de Accountant");
	end

	-- Etiquetas
	if AccountantOptionsFrameToggleButtonText then
		AccountantOptionsFrameToggleButtonText:SetText(L_MINIBUT);
	end
	if AccountantSliderButtonPosText then
		AccountantSliderButtonPosText:SetText(L_BUTPOS);
	end
	if AccountantOptionsFrameWeekLabel then
		AccountantOptionsFrameWeekLabel:SetText(L_STARTWEEK);
	end
	if AccountantOptionsFrameDone then
		AccountantOptionsFrameDone:SetText(ACCLOC_DONE or "Listo");
	end

	-- Estado de UI
	AccountantOptionsFrameToggleButton:SetChecked(Accountant_SaveData[GetCVar("realmName")][UnitName("player")]["options"].showbutton);
	AccountantSliderButtonPos:SetValue(Accountant_SaveData[GetCVar("realmName")][UnitName("player")]["options"].buttonpos);

	-- Dropdown semana
	UIDropDownMenu_SetWidth(AccountantOptionsFrameWeek, 140);
	UIDropDownMenu_JustifyText(AccountantOptionsFrameWeek, "LEFT");

	UIDropDownMenu_Initialize(AccountantOptionsFrameWeek, AccountantOptionsFrameWeek_Init);
	local sel = Accountant_SaveData[Accountant_Server][Accountant_Player]["options"].weekstart or 1;
	UIDropDownMenu_SetSelectedValue(AccountantOptionsFrameWeek, sel);
	UIDropDownMenu_SetText(AccountantOptionsFrameWeek, L_WD[sel] or L_WD[1]);
end

function AccountantOptions_OnHide()
	if(MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
end

function AccountantOptionsFrameWeek_Init()
	-- Lista de días (con fallback)
	local L_WD = {
		ACCLOC_WD_SUN or "Domingo",
		ACCLOC_WD_MON or "Lunes",
		ACCLOC_WD_TUE or "Martes",
		ACCLOC_WD_WED or "Miércoles",
		ACCLOC_WD_THU or "Jueves",
		ACCLOC_WD_FRI or "Viernes",
		ACCLOC_WD_SAT or "Sábado",
	}
	Accountant_DayList = L_WD;

	for i = 1, getn(Accountant_DayList) do
		local info = {};
		info.text = Accountant_DayList[i];
		info.func = AccountantOptionsFrameWeek_OnClick;
		info.value = i;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end

function AccountantOptionsFrameWeek_OnClick()
	local val = this.value or 1;
	UIDropDownMenu_SetSelectedValue(AccountantOptionsFrameWeek, val);
	local text = (Accountant_DayList and Accountant_DayList[val]) or (ACCLOC_WD_SUN or "Domingo");
	UIDropDownMenu_SetText(AccountantOptionsFrameWeek, text);
	Accountant_SaveData[Accountant_Server][Accountant_Player]["options"].weekstart = val;
end