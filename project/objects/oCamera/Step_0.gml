if (instance_exists(follow)) {
	if (follow == oPlayer) {
		if (follow.is_onfloor) && (follow.vsp == 0) {
			ground_level = follow.y;
		}
		
		if (follow.y > ground_level) || (follow.is_jump == 3) || (follow.is_wallslide) {
			y_to = follow.y;
			if (follow.vsp > 0) y_to += (follow.vsp*10);
		} else {
			y_to = ground_level;
		}
		
		if (!follow.is_changingdir) && (follow.is_jump != 3) && (!follow.is_wallslide) {
			x_to = follow.x + (follow.hsp*20);
		}

		
		/*switch (follow.dir) {
			case -1:
				// Facing left
				x_to = x 
			break;
			case 1:
				// Facing right
			break;
		}*/
	} else {
		x_to = follow.x;
		y_to = follow.y;
	}
	
	//if (x_to - x > cam_maxsp) x_to = x + cam_maxsp;
	
	x_to = clamp(x_to, view_w_half, room_width - view_w_half);
	y_to = clamp(y_to, view_h_half, room_height - view_h_half);
}

x += (x_to - x) / cam_pan;
y += (y_to - y) / cam_pan;

if (is_shake) {
	var angle = random_range(-0.5,0.5)
    camera_set_view_angle(global.cam, angle);
} else {
	camera_set_view_angle(global.cam,0);
}


camera_set_view_pos(global.cam, x - view_w_half, y - view_h_half);