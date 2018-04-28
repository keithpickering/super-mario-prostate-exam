hsp = 0;
vsp = 0;
vsp_max = 30;
grv = 0.6;
walksp = 1;
accel = 0.15;
decel = 0.15;

// Start moving left
move = -1;

// Status variables
dir = move;

is_dead = false;

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