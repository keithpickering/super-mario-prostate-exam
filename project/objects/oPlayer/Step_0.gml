/**
 * SETUP
 */
 
// Check pressed keys
key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_left_pressed = keyboard_check_pressed(vk_left);
key_right_pressed = keyboard_check_pressed(vk_right);
key_jump = keyboard_check(ord("Z"));
key_jump_pressed = keyboard_check_pressed(ord("Z"));
key_run = keyboard_check(ord("X"));
key_crouch = keyboard_check(vk_down);
key_crouch_released = keyboard_check_released(vk_down);

// Check if we're against a wall
was_onwall = is_onwall;
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
	if (abs(hsp) > walksp) {
		if (is_onfloor) {
			this_accel /= 8;
		} else {
			this_accel = 0;
		}
		
		// Keep track of run level
		/*if (run_level <= 5) {
			timer_run += 1;
			if (timer_run > 75) {
				run_level += 1;
				timer_run = 0;
			}
		}*/
	}
}
if (!is_onfloor) {
	// Decelerate slower in mid-air (more natural jump arc)
	this_decel /= 10;
	if (is_jump == 3) {
		// For walljumps, accelerate slower too
		// This forces us off the wall a little more
		// Otherwise you can keep from falling indefinitely
		this_accel /= 1.2;
	}
}
if (hsp < 0 && key_right) || (hsp > 0 && key_left) {
	// This makes it less slippery when quickly changing direction
	if (abs(hsp) <= walksp) {
		this_accel *= 1.5;
	} else {
		this_accel *= 3;
	}
}

if (is_onfloor) {
	// Status vars
	is_jump = 0;
	is_wallslide = 0;

	// Timers
	timer_groundpound = 0;
	timer_wallslide = 0;
	
	timer_jumpcancel++;
	if (timer_jumpcancel > 10) {
		timer_jumpcancel = 0;
		jump_current = 0;
	}
	
	// Show power meter if we stand still, just got hit, or are low on health
	if (abs(hsp) == 0) || (is_invincible) || (global.hp < 3) {
		if (timer_showhp <= 50) timer_showhp += 1;
		timer_hidehp = 0;
		if (abs(hsp == 0)) && (!is_invincible) {
			if (timer_showhp > 50) {
				global.show_hp = true;
			}
		} else {
			global.show_hp = true;
		}
	} else if (abs(hsp) > 0) {
		// If we start running, hide the power meter after a bit
		/*timer_hidehp += 1;
		if (timer_hidehp > 40) {
			global.show_hp = false;
		}
		timer_showhp = 0;*/
	}
	
	// Fall damage
	//if (timer_falldamage >= 100) scReduceHp();
	//timer_falldamage = 0;
	
	
	// Jumping
	if (key_jump_pressed) {
		if ((hsp < 0 && key_right) || (hsp > 0 && key_left)) && (move != 0) {
			// Side flip
			vsp = -jump_max * 1.15;
			hsp += move * sideflip_force;
			is_jump = 2;
			// Reset double/triple jump
			jump_current = 1;
		} else {
			// Regular jump
			var this_doublejump_multi = 1;
			// Double/triple jump counter
			if (timer_jumpcancel <= 10) {
				jump_current++;
				
				// Double jump can be done while standing still,
				// but Triple jump requires movement
				if (jump_current == 2) {
					this_doublejump_multi = 1.1;
				} else if (jump_current == 3) {
					if (abs(hsp) > 0) && (move != 0) {
						this_doublejump_multi = 1.2;
					} else {
						jump_current = 1;
					}
				} else if (jump_current > 3) {
					jump_current = 1;
				}
			}
			// Jump higher the faster we're moving
			var jump_multiplier = abs(hsp) / walksp;
			if (jump_multiplier > 1) {
				vsp = -jump_max * jump_multiplier * this_doublejump_multi;
				if (vsp < -jump_max_running) vsp = -jump_max_running;
			} else {
				vsp = -jump_max * this_doublejump_multi;
			}
			is_jump = 1;
		}
	}
	
	// Complete a ground pound
	if (is_groundpound) {
		// Shake the camera
		oCamera.is_shake = true;
		oCamera.alarm[0] = 5;
		
		// Stay stuck on the ground for a sec
		move = 0;
		timer_groundpound_done += 1;
		if (timer_groundpound_done >= 20) {
			is_groundpound = 0;
			timer_groundpound_done = 0;
		}
	} else {
		timer_groundpound_done = 0;
		if (key_crouch) {
			is_crouch = 1;
			move = 0;
		} else {
			is_crouch = 0;
		}
	}
	
	// Slide down slopes
	if (is_onslope != 0) {
		if (is_crouch) {
			hsp += 0.25 * is_onslope;
			this_decel /= 2;
		}
	}
	
	if (hsp != 0) {
		if (hsp < 0 && key_right) || (hsp > 0 && key_left) {
			if (is_jump == 1) {
				jump_current = 1;
			} else {
				jump_current = 0;
			}
		}
	}
} else {
	timer_jumpcancel = 0;

	// Increment fall damage counter
	/*if (is_onwall == 0) && (!is_groundpound) {
		timer_falldamage++;
	} else {
		timer_falldamage = 0;
	}*/
	
	// Check if jump key has been released while still moving up,
	// and if so prevent from jumping to the maximum height
	if (!key_jump) && (sign(vsp) == -1) {
		var jump_reduce = 1.5;
		if (is_jump == 2) || (jump_current > 1) jump_reduce = 1.1;
		vsp /= jump_reduce;	
	}
	
	if (is_wallslide != 0) {
		// Allow jumping away from the wall
		if (key_jump_pressed) {
			vsp = -jump_max / 1.1;
			// Jump in the correct direction
			hsp += walljump_force * is_onwall * -1;
			// Update vars
			is_wallslide = 0;
			is_jump = 3;
		}
	}
	if (is_onwall != 0) {
		jump_current = 0;
		
		if (vsp > 0) {
			if (!is_wallslide) {
				// Hit the wall just now
				// Turn around to face away from wall
				dir = is_onwall * -1;
				vsp = 0;
			}
			
			// Update vars
			is_wallslide = 1;
			is_jump = 0;
			
			// Prevent moving off the wall until we've been on it for 20 frames
			timer_wallslide += 1;
			if (timer_wallslide < 20){
				move = 0;
			}
		}
	} else {
		// If we're not on a wall, cancel wallsliding
		is_wallslide = 0;
		
		// Ground pound
		if (key_crouch) && (!is_groundpound) && (!is_crouch) {
			vsp = 8;
			hsp = 0;
			timer_groundpound = 0;
			is_groundpound = 1;
		} else if (is_groundpound) {
			hsp = 0;
			timer_groundpound += 1;
				
			if (timer_groundpound >= 20) {
				if (vsp < 1) {
					vsp = 3;
				} else {
					vsp *= 1.5;
				}
			} else {
				vsp -= 1.75;
			}
		}
	}
}

/**
 * HORIZONTAL MOVEMENT + EASING
 */
switch (move) {
	case 1:
		// Move right
		if (!is_wallslide) {
			if (is_jump != 2) && (jump_current != 3) {
				if (dir != 1) {
					is_changingdir = true;
					changedir_pos = x;
				}
				dir = 1;
			}
		}
		hsp += this_accel;
		if (hsp > hsp_max) hsp = hsp_max;
		
		break;
	case -1:
		// Move left
		if (!is_wallslide) {
			if (is_jump != 2) && (jump_current != 3) {
				if (dir != -1) {
					is_changingdir = true;
					changedir_pos = x;
				}
				dir = -1;
			}
		}
		if (sign(hsp) == 1) is_changingdir = true;
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

if (is_changingdir) {
	if (x > changedir_pos + changedir_limit) || (x < changedir_pos - changedir_limit) {
		is_changingdir = false; 
		changedir_pos = 0;
	}
}


/**
 * GRAVITY
 */
if (!is_groundpound) {
	if (!is_wallslide) {
		vsp = vsp + grv;
	} else {
		// Friction from wall
		vsp = vsp + grv - frc;
	}
}
if (vsp > vsp_max) vsp = vsp_max;


/**
 * ENEMY INTERACTIONS
 */
var this_enemy = instance_place(x, y, oEnemyParent);
if (this_enemy != noone) && (!this_enemy.is_dead) {
	if ((vsp > 0) && (!is_onfloor)) || (is_crouch) && (is_onslope) && (abs(hsp) > 4) {
		// If we're moving down, stomp the enemy
		with (this_enemy) {
			is_dead = true;
			alarm[0] = room_speed;
		}
		
		// Bounce off enemy
		if (!is_groundpound) vsp = -jump_max;
		
		// Reset the fall damage timer
		//timer_falldamage = 0;
		
		// Reset jump counter (can't bounce off an enemy and continue triple jump)
		// Setting to 1 makes bouncing off the enemy act as the first jump, so you
		// can kill an enemy then double jump next time you hit the ground
		jump_current = 1;
	} else if (!is_invincible) {
		// Get hurt
		scReduceHp();
		
		// Bounce back a bit
		//if (this_enemy.is_onfloor) vsp = -jump_max/2;
		if (sign(this_enemy.hsp) == sign(hsp)) {
			hsp = -walksp * sign(this_enemy.hsp);
		} else {
			hsp = walksp * sign(this_enemy.hsp);
		}
	}
}

/**
 * HEART ITEM
 */
var this_heart = instance_place(x, y, oHeart);
if (this_heart != noone) {
	scRestoreHp(1);
	
	// Destroy heart
	with (this_heart) {
		instance_destroy();	
	}
}


/**
 * COLLISION
 */
var collision_data = scCollision(x,y,hsp,vsp);
x = collision_data[0];
y = collision_data[1];
hsp = collision_data[2];
vsp = collision_data[3];


/**
 * ANIMATION
 */
if (!is_onfloor) && (!is_groundpound) {
	image_speed = 0;
	
	if (is_jump == 2) {
		// Side flip spin
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
		
		// Triple jump spin
		if (jump_current == 3) {
			if (abs(render_angle) < 360) {
				render_angle -= 10 * sign(dir);
			}
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
			if (key_left_pressed) || (key_right_pressed) image_index = 2;
			if (key_run) {
				image_speed *= 1.5;
				if (image_speed >= 2) image_speed = 2;
			}
		}		
	} else {
		// Todo: pushing animation
		// Idling
		if (sprite_index == sPlayerRun) {
			if (floor(image_index) < 6) {
				sprite_index = sPlayerIdle;
			}
		} else {
			sprite_index = sPlayerIdle;
		}
	}
	
	if (!key_left) && (!key_right) {
		// Slowing to a stop
		if (move == 0) && (sprite_index = sPlayerRun) {
			image_speed /= 1.75;
		}
	}
}

// Sliding down a wall
if (is_wallslide) {
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
if (key_crouch_released && is_onfloor) || (timer_groundpound_done >= 19 && !key_crouch) {
	sprite_index = sPlayerCrouch;
	image_speed = 0;
	image_index = 1;
} else if (is_groundpound) {
	if (!is_onfloor) {
		sprite_index = sPlayerRoll;
		image_speed = 0;
		if (timer_groundpound >= 20) {
			render_angle = 0;
		} else if (abs(render_angle) < 360) {
			render_angle -= 18 * sign(dir);
		}
	} else {
		sprite_index = sPlayerCrouch;
		image_speed = 0;
		render_angle = 0;
		image_index = 3;
	}
} else {
	if (draw_yscale < 0.9) && (move == 0 ) {
		sprite_index = sPlayerIdle;
		image_index = 16;
		image_speed = 0;
	}
}

// Flip sprite based on direction
draw_xscale = dir;

// Stretch on jump
if (key_jump_pressed) && (is_onfloor || is_onwall != 0) {
	draw_yscale = 1.4;
	draw_xscale = 0.75 * dir;
	if (is_onfloor) {
		instance_create_depth(x - sprite_get_width(sImpact)/2, y + sprite_height/2 - sprite_get_height(sImpact)/2 + 4, 1, oImpact);
	} else {
		//instance_create_depth(x, y, 1, oImpactWall);	
	}
} else if (timer_groundpound > 25) {
	draw_yscale = 1 + (timer_groundpound / 50);
	if (draw_yscale > 1.5) draw_yscale = 1.5;
	draw_xscale = 0.75 * dir;
}

// Gradually return to non-stretched values
draw_xscale = lerp(draw_xscale, dir, 0.1);
draw_yscale = lerp(draw_yscale, 1, 0.1);

// Squash on landing
if (place_meeting(x, y + 1, oWall)) && (!place_meeting(x, yprevious + 1, oWall)) && (!place_meeting(xprevious, yprevious + 1, oWall)) {
	draw_xscale = 1.25 * dir;
	var y_amt = vsp / 9;
	if (y_amt < 0.75) {
		y_amt = 0.75;
	} else if (y_amt > 0.9) {
		y_amt = 0.9;
	}
	draw_yscale = y_amt;
}

if (is_hurt) {
	render_angle = 0;
	is_hurt = false;
}

// Adjust y position (visual only)
y_correct = (sprite_height - (sprite_height*draw_yscale)) / 2;

if (is_invincible) {
	image_alpha = 0.5;
} else {
	image_alpha = 1;
}
