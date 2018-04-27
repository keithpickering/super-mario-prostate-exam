// Global variables
global.debug = true;
global.hp = 3;

global.show_hp = false;

timer_cleanup = 0;

timer_pm_pulse = 0;

pmy = sprite_get_height(sPowerMeter) * -1;
pm_scale = 1;

// Create the camera if it doesn't exist
if (!instance_exists(oCamera)) && (instance_exists(oPlayer)) {
	instance_create_depth(oPlayer.x, oPlayer.y, 0, oCamera);
}

if (!instance_exists(oHud)) {
	//var powx = (camera_get_view_width(global.cam) * 0.5) - (sprite_get_width(sPowerMeter) / 2);
	//instance_create_depth(0, 0, 1000, oHud);
}