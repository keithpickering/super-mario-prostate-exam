/**
 * OBJECT ACTIVATE / DEACTIVATE
 */
if (timer_cleanup > 10) {
	instance_activate_all();
	instance_deactivate_region(camera_get_view_x(global.cam) - 64, camera_get_view_y(global.cam) - 64, camera_get_view_width(global.cam) + 128, camera_get_view_height(global.cam) + 128, false, true);
	instance_activate_object(oWall);
	timer_cleanup = 0;
} else {
	timer_cleanup++;
}
