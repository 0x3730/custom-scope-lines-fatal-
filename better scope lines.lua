local menu = fatality.menu
local config = fatality.config
local comboRemoveScope = menu:get_reference('visuals', 'misc', 'local', 'remove scope');

local lines_enable = config:add_item("lines_enable", 1);
local guiLinesCheckbox = menu:add_checkbox("Enable Custom Scope Lines", "visuals", "misc", "local", lines_enable);

local margin_lines = config:add_item("margin_lines", 15);
local guiMarginSlider = menu:add_slider("Scope Lines Margin", "visuals", "misc", "local", margin_lines, 0, 1000, 1);

local size_lines = config:add_item("size_lines", 200);
local guiSizeSlider = menu:add_slider("Scope Lines Size", "visuals", "misc", "local", size_lines, 0, 1000, 1);

--
local render = fatality.render
local callbacks = fatality.callbacks;
local ConVar = csgo.interface_handler:get_cvar();
local screenCenter = render:screen_size();
screenCenter.x = screenCenter.x * 0.5;
screenCenter.y = screenCenter.y * 0.5;
--

local r, g, b = 194, 200, 255; -- change it if u wanna to change lines color

local function scopeline_handler()
	if not lines_enable:get_bool() then
		return;
	end
	
	if not csgo.interface_handler:get_engine_client():is_in_game() then
		return;
	end
	
	local localPlayer = csgo.interface_handler:get_entity_list():get_localplayer();
	
	if not localPlayer:is_alive() then
        return 
	end
	
	if comboRemoveScope:get_int() ~= 2 then
		comboRemoveScope:set_int(2);
	end
	
	local hudCvar = ConVar:find_var("cl_drawhud");
	if not localPlayer:get_var_bool("CCSPlayer->m_bIsScoped") then
		hudCvar:set_int(1);
		return;
	end
	
	hudCvar:set_int(0);
	local margin = margin_lines:get_int();
	local size = size_lines:get_int();
	local color = csgo.color(r, g, b, 255);
	local color2 = csgo.color(r, g, b, 50);
	
	render:rect_fade(screenCenter.x - size - margin, screenCenter.y, size, 1, color2, color, true); -- left
	render:rect_fade(screenCenter.x + margin, screenCenter.y, size, 1, color, color2, true); --right
	render:rect_fade(screenCenter.x, screenCenter.y - size - margin, 1, size, color2, color, false); -- top
	render:rect_fade(screenCenter.x, screenCenter.y + margin, 1, size, color, color2, false); -- down
end

callbacks:add("paint", scopeline_handler);