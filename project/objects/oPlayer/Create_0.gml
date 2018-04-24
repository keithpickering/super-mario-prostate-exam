hsp = 0;
vsp = 0;
vsp_max = 30;
grv = 0.6;
frc = 0.5;
walksp = 5;
runsp = 9;
wallslidesp = 6;
accel = 0.15;
decel = 0.15;
changedir_limit = 48; // Amount we can move in the other direction before the camera starts moving

// Store the difference between bottom/center origin
origin_diff = 38;

jump_max = 16.5;
jump_max_running = 18.5;
jump_current = 0;
walljump_force = walksp;
sideflip_force = 3.5;

// Status variables
dir = 1;
is_changingdir = false;
changedir_pos = 0;


/**
 * Check if we're against a wall
 * -1: Left wall
 *  1: Right wall
 */
is_onwall = 0;

/**
 * Check if we're sliding down a wall
 */
is_wallslide = 0;

/**
 * Check if we're on the floor
 */
is_onfloor = 0;

/**
 * Check if we're crouching
 */
is_crouch = 0;

/**
 * Check if we're ground pounding
 */
is_groundpound = 0;

/**
 * Check if we're jumping, and the type of jump
 * 1: Normal jump
 * 2: Side flip
 * 3: Walljump
 */
is_jump = 0;

/**
 * Variables to handle running (could be visualized with a P-meter)
 */
run_arr = [5,6,7,8,9,10];
run_level = 1;





// Draw variables
render_angle = 0;
draw_xscale = 1;
draw_yscale = 1;
y_correct = 0;

// Timers
timer_groundpound = 0;
timer_groundpound_done = 0;
timer_sideflip = 0;
timer_wallslide = 0;
timer_run = 0;