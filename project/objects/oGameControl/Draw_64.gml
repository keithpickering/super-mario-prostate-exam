draw_set_color(c_white);

if (global.debug) {
	draw_text(5, 5, "onfloor: " + string(oPlayer.is_onfloor));
	draw_text(5, 25, "onwall: " + string(oPlayer.is_onwall));
	draw_text(5, 45, "wallslide: " + string(oPlayer.is_wallslide));
	draw_text(5, 65, "jump: " + string(oPlayer.is_jump));
	draw_text(5, 85, "groundpound: " + string(oPlayer.is_groundpound));
	draw_text(5, 105, "crouch: " + string(oPlayer.is_crouch));
	draw_text(5, 125, "hsp: " + string(oPlayer.hsp));
	draw_text(5, 145, "vsp: " + string(oPlayer.vsp));
	draw_text(5, 165, "y correct: " + string(oPlayer.y_correct));
}

