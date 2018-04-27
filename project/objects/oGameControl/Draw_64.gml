draw_set_color(c_white);

if (global.debug) {
	draw_text(5, 5, "onfloor: " + string(oPlayer.is_onfloor));
	draw_text(5, 25, "onwall: " + string(oPlayer.is_onwall));
	draw_text(5, 45, "wallslide: " + string(oPlayer.is_wallslide));
	draw_text(5, 65, "jump: " + string(oPlayer.is_jump));
	draw_text(5, 85, "groundpound: " + string(oPlayer.is_groundpound));
	draw_text(5, 105, "hsp: " + string(oPlayer.hsp));
	draw_text(5, 125, "vsp: " + string(oPlayer.vsp));
	draw_text(5, 145, "hp: " + string(global.hp));
	draw_text(5, 165, "invincible: " + string(oPlayer.is_invincible));
}

// Draw power meter
var pmh = sprite_get_height(sPowerMeter);
if (global.show_hp) || (pmy > -pmh) {
	var pmw = sprite_get_width(sPowerMeter);
	var pmx = x + (camera_get_view_width(global.cam)/2 - pmw);
	var y_final = (global.show_hp) ? y + 10 : -pmh;
	pmy = lerp(pmy, y_final, 0.1);
	draw_sprite_part(sPowerMeter, global.hp, 0, 0, pmw, pmh, pmx, pmy);
}