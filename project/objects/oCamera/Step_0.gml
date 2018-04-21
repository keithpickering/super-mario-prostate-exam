if (instance_exists(follow)) {
	if (follow == oPlayer) {
		//if (!follow.is_changingdir) && (!follow.is_walljumping) && (!follow.is_wallsliding) {
		//	x_to = follow.x + (view_w_half/3 * sign(follow.dir));
		//}
		//y_to = follow.y;
		
		//if (follow.vsp > 0) y_to = follow.y + (follow.vsp * 10);
		
		//var getting_away = !follow.is_onfloor && point_distance(x, y, follow.x, follow.y) > view_h_half/2;
		
		//if (follow.is_onfloor) || (getting_away) || (follow.is_walljumping) {
			//y_to = follow.y;
			/*if (follow.is_onfloor) || (abs(follow.vsp) > follow.jump_max) || (follow.is_walljumping) || (follow.is_wallsliding) {
				if (follow.is_walljumping) || (follow.is_wallsliding) {
					y_to = follow.y;
				} else {
					y_to = follow.y + follow.vsp + (view_h_half/2 * sign(follow.vsp));
				}
			}*/
		//}
		
		//y_to = follow.y + follow.vsp*10;
		
		//var is_onfloor_justnow = !place_meeting(follow.x, follow.yprevious + 1, oWall) && follow.is_onfloor;
		
		if (follow.is_onfloor) && (follow.vsp == 0) {
			ground_level = follow.y;
		}
		
		if (follow.y > ground_level) || (follow.is_walljumping) || (follow.is_wallsliding) {
			y_to = follow.y;
			if (follow.vsp > 0) y_to += (follow.vsp*10);
			//ground_level = y_to;
		} else {
			y_to = ground_level;
		}
		
		if (!follow.is_changingdir) && (!follow.is_walljumping) && (!follow.is_wallsliding) {
			x_to = follow.x + (follow.hsp*20);
		}
		
		show_debug_message(follow.is_walljumping);

		
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


camera_set_view_pos(cam, x - view_w_half, y - view_h_half);