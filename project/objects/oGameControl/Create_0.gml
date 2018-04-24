// Global variables
global.debug = true;
global.hp = 3;

// Create the camera if it doesn't exist
if (!instance_exists(oCamera)) && (instance_exists(oPlayer)) {
	instance_create_depth(oPlayer.x, oPlayer.y, 0, oCamera);
}