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
	draw_text(5, 165, "jump current: " + string(oPlayer.jump_current));
	//draw_text(5, 185, "jump cancel: " + string(oPlayer.timer_jumpcancel));
}

/**
 * POWER METER
 */

// Timer for sliding animation
if (timer_pm_slide == pm_time) || (pmy == y_final) {
	// If the animation is done, it's safe to update our start/end position values
	timer_pm_slide = 0;
	pmy = y_final;
	y_final = (global.show_hp) ? pmh+10 : -pmh;
} else {
	timer_pm_slide++;
}

// Calculate this frame's position
var this_pmy = EaseInOutBack(timer_pm_slide, pmy, y_final-pmy, pm_time);
	
// Pulsating at 1HP
var scale_target = 1;
if (global.hp == 1) {
	if (timer_pm_pulse > 50) {
		timer_pm_pulse = 0;
		scale_target = 1;
	} else {
		timer_pm_pulse += 1;
		if (timer_pm_pulse > 10) {
			scale_target = 1.1;
		} else {
			scale_target = 0.75;
		}
	}
}
pm_scale = lerp(pm_scale, scale_target, 0.1);

// Finally draw the meter
draw_sprite_ext(sPowerMeter, global.hp, pmx, this_pmy, pm_scale, pm_scale, 0, c_white, 1);