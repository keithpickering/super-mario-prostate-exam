/**
 * SETUP
 */
 
// Check pressed keys
key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_jump = keyboard_check(vk_space);
key_jump_pressed = keyboard_check_pressed(vk_space);
key_run = keyboard_check(vk_control);
key_crouch = keyboard_check(vk_down);
key_crouch_released = keyboard_check_released(vk_down);

// Check status vars
is_onfloor = place_meeting(x, y + 1, oWall);
is_onwall_r = place_meeting(x + 1, y, oWall);
is_onwall_l = place_meeting(x - 1, y, oWall);

// Calculate movement direction
var move = key_right - key_left;

// Determine max horizontal speed
var hsp_max = 0;
var this_accel = accel;
var this_decel = decel;
if (!key_run) {
	// Normal speed
	hsp_max = move * walksp;
} else {
	// Running speed
	hsp_max = move * runsp;
	// Accelerate slowly toward the max run speed
	// If jumping, stop accelerating
	if (abs(hsp) > walksp) && (is_onfloor) this_accel /= 20;
}
if (!is_onfloor) && (!is_walljumping) {
	// Accelerate quicker in mid-air (more precise control)
	// Decelerate slower (more natural jump arc)
	this_accel *= 2;
	this_decel /= 3;
}
if (hsp < 0 && key_right) || (hsp > 0 && key_left) {
	// This makes it less slippery when quickly changing direction
	this_accel *= 1.5;	
}
if (is_onwall_l) || (is_onwall_r) {
	// Reset running speed
	//if (hsp >= walksp) hsp = walksp;
}



/**
 * JUMPING
 */
if (is_onfloor) && (key_jump_pressed) {
	// Side flip
	if (hsp < 0 && key_right) || (hsp > 0 && key_left) {
		// Turning around (skidding)
		vsp = -jump_max * 1.15;
		hsp += move * sideflip_force;
		is_sideflip = true;
	} else {
		// Jump higher the faster we're moving
		var jump_multiplier = abs(hsp) / walksp;
		if (jump_multiplier > 1) {
			vsp = -jump_max * jump_multiplier;
			if (vsp < -jump_max_running) vsp = -jump_max_running;
		} else {
			vsp = -jump_max;
		}
		is_jumping = true;
	}
} else if (is_onwall_l) || (is_onwall_r) || (is_onfloor) {
	is_jumping = false;
	is_sideflip = false;
}
// Check if jump key has been released while still moving up,
// and if so prevent from jumping to the maximum height
if (!key_jump) && (sign(vsp) == -1) {
	vsp /= 1.5;	
}


/**
 * WALL JUMPING
 */
if (is_onwall_r || is_onwall_l) && (!is_onfloor) && (vsp > 0) {
	// We're on a wall, not on the floor, and moving down. AKA sliding	
	// If we just came into contact with the wall, set a constant
	// vertical speed to start
	if (!is_wallsliding) {
		vsp = 1;
		// Turn around
		if (is_onwall_l) {
			dir = 1;
		} else {
			dir = -1;
		}
	}
	// Increase vertical speed as we slide down
	vsp *= 1.05;
	if (vsp > wallslidesp) vsp = wallslidesp;
	
	// Update vars
	is_wallsliding = true;
	is_walljumping = false;
	
	// Allow jumping away from the wall
	if (key_jump_pressed) {
		vsp = -jump_max / 1.1;
		if (is_onwall_r) {
			// Jump to the left
			hsp += -walljump_force;
		} else {
			// Jump to the right
			hsp += walljump_force;
		}
		// Update vars
		is_wallsliding = false;
		is_walljumping = true;
	}
} else if (is_onfloor) {
	// On the floor = no longer jumping
	is_walljumping = false;
	
	if (!is_onwall_r && !is_onwall_l) {
		// Stop sliding if we reach the floor or are
		// no longer against a wall
		is_wallsliding = false;
	}
} else if (is_walljumping) {
	// Decrease walljump force as we move away from the wall
	//hsp -= lerp(0, walljump_force*sign(hsp), 0.00001);
	hsp = walljump_force * sign(hsp);
} else {
	// Restore normal gravity if we cancel sliding
	is_wallsliding = false;
}


/**
 * CROUCHING / GROUND POUND
 */
if (key_crouch) {
	// Cancel any movement
	move = 0;
	if (!is_onfloor) && (!is_onwall_l) && (!is_onwall_r) {
		// Ground pound
		if (!is_groundpound) {
			vsp = 0;
			hsp = 0;
			timer_groundpound = 0;
			is_groundpound = true;
		}
	} else {
		// Just a crouch
	}
}
if (is_groundpound) {
	hsp = 0;
	timer_groundpound += 1;
	if (timer_groundpound >= 20) {
		if (vsp < 1) {
			vsp = 1;
		} else {
			vsp *= 1.5;
		}
	} else {
		vsp = 0;
	}
}
if (is_onfloor) {
	is_groundpound = false;
	timer_groundpound = 0;
}


/**
 * HORIZONTAL MOVEMENT + EASING
 */
switch (move) {
	case 1:
		// Move right
		if (!is_wallsliding || !is_onwall_r) {
			if (dir != 1) {
				is_changingdir = true;
				changedir_pos = x;
			}
			dir = 1;
		}
		hsp += this_accel;
		if (hsp > hsp_max) hsp = hsp_max;
		break;
	case -1:
		// Move left
		if (!is_wallsliding || !is_onwall_l) {
			if (dir != -1) {
				is_changingdir = true;
				changedir_pos = x;
			}
			dir = -1;	
		}
		if (sign(hsp) == 1) is_changingdir = true;
		hsp -= this_accel;
		if (hsp < hsp_max) hsp = hsp_max;
		break;
	case 0:
		// Movement ended - decelerate to stop
		if (hsp >= this_decel) hsp -= this_decel;
		if (hsp <= -this_decel) hsp += this_decel;
		if (hsp > -this_decel) && (hsp < this_decel) hsp = 0;
		break;
}
if (is_changingdir) {
	if (x > changedir_pos + changedir_limit) || (x < changedir_pos - changedir_limit) {
		is_changingdir = false;
		changedir_pos = 0;
	}
}



/**
 * GRAVITY
 */
if (!is_wallsliding) && (!is_groundpound) {
	vsp = vsp + grv;
}



/**
 * TERMINAL VELOCITY
 */
if (vsp > vsp_max) vsp = vsp_max;


/**
 * HORIZONTAL COLLISION
 */
if (place_meeting(x + hsp, y, oWall)) {
	while (!place_meeting(x + sign(hsp), y, oWall)) {
		x += sign(hsp);
	}
	hsp = 0;
}
x += hsp;


/**
 * VERTICAL COLLISION
 */
if (place_meeting(x, y + vsp, oWall)) {
	while (!place_meeting(x, y + sign(vsp), oWall)) {
		y += sign(vsp);
	}
	vsp = 0;
}
y += vsp;


/**
 * ANIMATION
 */


if (!is_onfloor) && (!is_groundpound) {
	image_speed = 0;
	
	if (is_sideflip) {
		if (abs(render_angle) < 360) {
			sprite_index = sPlayerFlip;
			render_angle -= 10 * sign(dir);
		} else {
			sprite_index = sPlayerJump;
			image_index = 1;
		}
	} else {
		sprite_index = sPlayerJump;
		if (sign(vsp) > 0) {
			image_index = 1;
		} else {
			image_index = 0;
		}
	}
} else if (is_onfloor) {
	image_speed = 1;
	render_angle = 0;
	
	if (hsp != 0) {
		if (hsp < 0 && key_right) || (hsp > 0 && key_left) {
			// Turning around (skidding)
			sprite_index = sPlayerSkid
		} else {
			// Running
			sprite_index = sPlayerRun;
			if (key_run) {
				image_speed *= 1.5;
				if (image_speed >= 2) image_speed = 2;
			}
		}		
	} else {
		// Todo: pushing animation
		// Idling
		sprite_index = sPlayerIdle;
	}
	
	if (!key_left) && (!key_right) {
		// Slowing to a stop
		if (move == 0) && (sprite_index = sPlayerRun) {
			image_speed /= 1.75;
		}
	}
}

// Sliding down a wall
if (is_onwall_r || is_onwall_l) && (!is_onfloor) && (vsp > 0) {
	sprite_index = sPlayerSlide;
	render_angle = 0;
}

// Crouching / Ground Pound
if (key_crouch) {
	if (is_onfloor) {
		sprite_index = sPlayerCrouch;
		if (keyboard_check_pressed(vk_down)) {
			// Fix animation bug
			image_index = 0;
		}
		image_speed = 1;
		if (floor(image_index) == image_number - 1) {
			image_speed = 0;
		}
	}
}
if (key_crouch_released) && (is_onfloor) {
	sprite_index = sPlayerCrouch;
	image_speed = 0;
	image_index = 2;
}
if (is_groundpound) {
	sprite_index = sPlayerCrouch;
	image_speed = 0;
	image_index = 3;
	if (timer_groundpound >= 20) {
		render_angle = 0;
	} else {
		render_angle -= 18 * sign(dir);
	}
}

// Flip sprite based on direction
draw_xscale = dir;

show_debug_message(is_wallsliding);