global.cam = view_camera[0];
follow = oPlayer;
view_w_half = camera_get_view_width(global.cam) * 0.5;
view_h_half = camera_get_view_height(global.cam) * 0.5;
x_to = xstart;
y_to = ystart;
is_shake = false;

cam_pan = 25;
ground_level = 0;