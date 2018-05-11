/**
 * Movement variables
 */
hsp = 0;
vsp = 0;
vsp_max = 20;
grv = 0.6;
frc = 0.5; // Friction when sliding down a wall
walksp = 5.5;
runsp = 9;
wallslidesp = 6;
accel = 0.15;
decel = 0.15;

/**
 * Jump-specific variables
 */
jump_max = 17;
jump_max_running = 19;
jump_current = 0; // For double/triple jump
walljump_force = 5;
sideflip_force = 3.5;

/**
 * Keep track of our direction
 * -1: Left
 *  1: Right
 */
dir = 1;

/**
 * Check when we're changing direction to keep the camera still
 */
is_changingdir = false;
changedir_limit = 48; // Amount we can move in the other direction before the camera starts moving
changedir_pos = 0;

/**
 * Check if we're on a slope
 * -1: Left facing slope
 *  1: Right facing slope
 */
is_onslope = 0;

/**
 * Check if we're against a wall
 * -1: Left wall
 *  1: Right wall
 */
is_onwall = 0;
was_onwall = 0;

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
 * 4: Long jump
 */
is_jump = 0;

/**
 * Toggle invincibility
 */
is_invincible = false;

is_hurt = false;



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
timer_showhp = 0;
timer_hidehp = 0;
timer_falldamage = 0;
timer_jumpcancel = 0;
timer_crouch = 0;