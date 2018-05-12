hsp = 0;
vsp = 0;
vsp_max = 30;
grv = 0.6;
walksp = 1;
accel = 0.05;
decel = 0.05;
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

is_dying = false;
is_dead = false;
is_noclip = false;
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
is_changingdir = false;

y_correct = 0;

timer_confused = 0;
timer_wander = 0;
timer_changedir = 0;

/**
 * Mutually exclusive states
 *
 * 0: Traditional goomba-like behavior
 * 1: Wandering
 * 2: Alert
 * 3: Chasing the player
 * 4: Confused
 */
state = 0;