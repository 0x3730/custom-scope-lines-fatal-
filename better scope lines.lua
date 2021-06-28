local render = fatality.render
local callbacks = fatality.callbacks;
local ConVar = csgo.interface_handler:get_cvar();
local screenCenter = render:screen_size();
screenCenter.x = screenCenter.x * 0.5;
screenCenter.y = screenCenter.y * 0.5;


local function on_paint()
	if not lines_enable:get_bool() then
		return;
	end
	
	local localPlayer = csgo.interface_handler:get_entity_list():get_localplayer();
	if not localPlayer:is_in_game() then
		return;
	end
	
	local hudCvar = ConVar:find_var("cl_drawhud");
	
	if not localPlayer:is_alive() then
		hudCvar:set_int(1);
        return 
	end
	
	if comboRemoveScope:get_int() ~= 2 then
		comboRemoveScope:set_int(2);
	end
	
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

callbacks:add("paint", on_paint);
