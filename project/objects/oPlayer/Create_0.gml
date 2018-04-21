hsp = 0;
vsp = 0;
vsp_max = 20;
grv = 0.6;
walksp = 5;
runsp = 9;
wallslidesp = 6;
accel = 0.15;
decel = 0.15;
changedir_limit = 48; // Amount we can move in the other direction before the camera starts moving

jump_max = 17;
jump_max_running = 18.5;
jump_current = 0;
walljump_force = 5;
sideflip_force = 2;

// Status variables
dir = 1;
is_againstwall = false;
is_onfloor = false;
is_jumping = false;
is_sideflip = false;
is_wallsliding = false;
is_walljumping = false;
is_groundpound = false;
is_changingdir = false;
changedir_pos = 0;

// Draw variables
render_angle = 0;
draw_xscale = 1;
draw_yscale = 1;

// Timers
timer_groundpound = 0;