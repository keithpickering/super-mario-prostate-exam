/**
 * SETUP
 */
 
// Check if against a wall
if (place_meeting(x + 1, y, oWall)) {
	is_onwall = 1;
} else if (place_meeting(x - 1, y, oWall)) {
	is_onwall = -1;
} else {
	is_onwall = 0;
}

// Check if on the floor
is_onfloor = place_meeting(x, y + 1, oWall);

// Determine max horizontal speed
var hsp_max = move * walksp;
var this_accel = accel;
var this_decel = decel;

if (is_onwall == 1) {
	move = -1;
} else if (is_onwall == -1) {
	move = 1;
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

/**
 * GRAVITY
 */
vsp = vsp + grv;

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


// Flip sprite based on direction
draw_xscale = dir;

