/**
 * SETUP
 */
 
if (!is_dead) && (!is_dying) {
	// Check if against a wall
	if (place_meeting(x + 1, y, oWall)) {
		is_onwall = 1;
	} else if (place_meeting(x - 1, y, oWall)) {
		is_onwall = -1;
	} else {
		is_onwall = 0;
	}

	// Check if we're on the floor
	is_onfloor = place_meeting(x, y + 1, oWall);
	is_onslope = 0;
	if (place_meeting(x + 2, y + 1, oSlope)) {
		is_onslope = -1;
	} else if (place_meeting(x - 2, y + 1, oSlope)) {
		is_onslope = 1;
	}
	
	// Determine max horizontal speed
	var hsp_max = move * walksp;
	var this_accel = accel;
	var this_decel = decel;
	
	if (wander) {
		if (is_alert) {
			// We just saw the player, jump in surprise
			vsp -= 7.5;
			is_alert = false;
			is_chasing = true;
			is_confused = false;
			is_jump = true;
		} else if (is_chasing) {
			image_speed = 2;
			if (is_onfloor) {
				// Surprised jump is done, start chasing player
				var side;
				if (x > oPlayer.x) {
					side = 1;
				} else {
					side = -1;
				}
				
				move = -side;
				hsp_max = move * walksp * 2;
			
				var leavealone_dist;
				if (dir == -1 && x > oPlayer.x) || (dir == 1 && x < oPlayer.x) {
					leavealone_dist = 500;
				} else {
					leavealone_dist = 200;
				}
					
				if (distance_to_object(oPlayer) > leavealone_dist) {
					is_chasing = false;
					is_confused = true;
					move = 0;
				}
			}
		} else if (distance_to_object(oPlayer) < 300) && ((dir == -1 && x > oPlayer.x) || (dir == 1 && x < oPlayer.x)) {
			// We can see the player, stop wandering
			if (timer_wander > 15) {
				is_alert = true;
				is_wander = false;
				is_confused = false;
			}
		} else if (instance_place(x, y, oPlayer)) {
			// Player bumped us from behind
			is_alert = true;
			is_wander = false;
			is_confused = false;
		} else if (is_confused) {
			move = 0;
			timer_confused++;
			if (timer_confused > 50) {
				is_confused = false;
				timer_confused = 0;
			}
		} else if (!is_wander) {
			is_wander = true;
			is_confused = false;
			alarm[1] = random_range(100, 200);
		}
		
		if (is_wander) {
			timer_wander++;
		}
		
		if (!is_chasing) {
			image_speed = 1;
		}
	}
	
	if (move == 0) {
		image_speed = 0;
		image_index = 1;
	}

	var dist_to_player = distance_to_object(oPlayer);
	if (oPlayer.is_groundpound) && (oPlayer.is_onfloor) && (dist_to_player < 100) && (!is_dead) {
		move = 0;
		if (oPlayer.timer_groundpound_done == 1) {
			var move_dist = 100/dist_to_player;
			if (move_dist > 5) move_dist = 5;
			vsp = -move_dist*2;
			if (oPlayer.x > x) {
				hsp = -move_dist/2;
			} else {
				hsp = move_dist/2;
			}
		}
	}

	/**
	 * HORIZONTAL MOVEMENT + EASING
	 */
	switch (move) {
		case 1:
			// Move right
			dir = 1;
			hsp += this_accel;
			if (hsp > hsp_max) hsp = hsp_max;
			break;
		case -1:
			// Move left
			dir = -1;
			hsp -= this_accel;
			if (hsp < hsp_max) hsp = hsp_max;
			break;
		case 0:
			// Movement ended - decelerate to stop
			if (hsp >= this_decel) {
				hsp -= this_decel;
			} else if (hsp <= -this_decel) {
				hsp += this_decel;
			} else if (hsp > -this_decel) && (hsp < this_decel) {
				hsp = 0;
			}
			break;
	}
} else if (is_dying) {
	is_noclip = true;
	is_chasing = false;
	is_alert = false;
	is_wander = false;
	// Destroy once we're out of view
	if ((bbox_right <= camera_get_view_x(global.cam)) && (bbox_left >= camera_get_view_x(global.cam) + camera_get_view_width(global.cam)) && (bbox_bottom <= camera_get_view_y(global.cam)) && (bbox_top >= camera_get_view_y(global.cam) + camera_get_view_height(global.cam))) {
	   instance_destroy();
	}
} else if (is_dead) {
	// We dead, don't move
	hsp = 0;
}

/**
 * GRAVITY
 */
vsp = vsp + grv;

/**
 * TERMINAL VELOCITY
 */
if (vsp > vsp_max) vsp = vsp_max;

/**
 * COLLISION
 */
if (!is_noclip) {
	// Handle colliding with another enemy
	var other_enemy = instance_place(x, y, oEnemyParent);
	if (other_enemy != noone) && (!other_enemy.is_dead) {
		var move_dis = 1;
		var turn_dir;
	
		// Figure out which direction to turn
		//if (x == other_enemy.x && y == other_enemy.y) {
		//	turn_dir = random(360);
		//} else {
			turn_dir = point_direction(other_enemy.x,other_enemy.y,x,y);
		//}
	
		var dx = lengthdir_x(move_dis,turn_dir);
		var dy = lengthdir_y(move_dis,turn_dir);
	
		// Start moving the determined direction
		move = sign(dx);

		// Move as long as there isn't a wall
		//if (!place_meeting(x + dx, y, oWall)) x += dx;
		//if (!place_meeting(x, y + dy, oWall)) y += dy;
	
		hsp = sign(dx) * walksp;
	}

	// Turn around if we hit a wall
	if (is_onwall == 1) && (is_onslope == 0) {
		move = -1;
	} else if (is_onwall == -1) && (is_onslope == 0) {
		move = 1;
	}

	var collision_data = scCollision(x,y,hsp,vsp);
	x = collision_data[0];
	y = collision_data[1];
	hsp = collision_data[2];
	vsp = collision_data[3];
} else {
	x += hsp;
	y += vsp;
}


// Flip sprite based on direction
draw_xscale = dir;



// Stretch on jump
if (is_jump) {
	is_jump = false;
	draw_yscale = 1.5;
	draw_xscale = 0.75 * dir;
}

// Gradually return to non-stretched values
draw_xscale = lerp(draw_xscale, dir, 0.1);
draw_yscale = lerp(draw_yscale, 1, 0.1);

// Squash on landing
if (place_meeting(x, y + 1, oWall)) && (!place_meeting(x, yprevious + 1, oWall)) && (!place_meeting(xprevious, yprevious + 1, oWall)) {
	draw_xscale = 1.25 * dir;
	draw_yscale = 0.75;
}

// Adjust y position (visual only)
y_correct = (sprite_height - (sprite_height*draw_yscale)) / 2;

if (is_dying) {
	draw_yscale = -1;
	image_speed = 0;
	y_correct = 0;
}
