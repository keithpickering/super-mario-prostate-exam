// Global variables
global.debug = true;
global.hp_max = 3;
global.hp = global.hp_max;

global.show_hp = true;

timer_cleanup = 0;

timer_pm_slide = 0;
timer_pm_pulse = 0;

// Create the camera if it doesn't exist
if (!instance_exists(oCamera)) && (instance_exists(oPlayer)) {
	instance_create_depth(oPlayer.x, oPlayer.y, 0, oCamera);
}

pmw = sprite_get_width(sPowerMeter);
pmh = sprite_get_height(sPowerMeter);
pmx = camera_get_view_width(global.cam) - pmw;
pmy = -pmh;
y_final = pmh+10;
pm_scale = 1;
pm_time = 50;
