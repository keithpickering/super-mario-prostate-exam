hsp = 0;
vsp = 0;
vsp_max = 30;
grv = 0.6;
walksp = 1;
accel = 0.15;
decel = 0.15;
wander = false;
is_wander = false;
is_alert = false;
is_chasing = false;

// Check if this particular instance is supposed to
// wander around, or just move until it hits a wall
if (wander) {
	//is_wander = true;
} else {
	// Start moving left
	move = -1;
}

// Status variables
dir = move;

is_dead = false;
is_turningaround = false;
gettingout = false;

// Used for correcting slope positioning on some enemies
push_current = 0;

/**
 * Check if against a wall
 * -1: Left wall
 *  1: Right wall
 */
is_onwall = 0;

/**
 * Check if on the floor
 */
is_onfloor = 0;

// Draw variables
render_angle = 0;
draw_xscale = 1;
draw_yscale = 1;

is_confused = false;
is_jump = false;

y_correct = 0;