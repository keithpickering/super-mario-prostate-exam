// Fix walking on air on slopes
var this_y = y;
var this_x = x;
/*var push = 6;
if (is_onslope != 0) {
	if (push_current < push) {
		push_current++;
	}

	if (is_onslope == -1) {
		if (hsp > 0) {
			// Up to the right
			this_x += push_current;
			this_y -= push_current;
		} else if (hsp < 0) {
			// Down to the left
			this_x += push_current;
			this_y += push_current;
		}
	} else {
		if (hsp > 0) {
			// Down to the right
			this_x -= push_current;
			this_y += push_current;
		} else if (hsp < 0) {
			// Up to the left
			this_x -= push_current;
			this_y -= push_current;
		}
	}
} else {
	push_current = 0;
}*/

draw_sprite_ext(sprite_index, image_index, this_x, this_y, draw_xscale, draw_yscale, render_angle, image_blend, image_alpha);