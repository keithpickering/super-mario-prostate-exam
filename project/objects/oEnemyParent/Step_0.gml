/**
 * SETUP
 */
 
if (!is_dead) {
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
} else {
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

/**
 * COLLISION
 */
var collision_data = scCollision(x,y,hsp,vsp);
x = collision_data[0];
y = collision_data[1];
hsp = collision_data[2];
vsp = collision_data[3];


// Flip sprite based on direction
draw_xscale = dir;

