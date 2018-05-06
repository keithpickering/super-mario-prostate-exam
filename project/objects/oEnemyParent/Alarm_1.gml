/// @description Start wandering

is_confused = false;

// Randomly start moving either left or right
move = choose(-1, 1);
// Stop moving after a few steps
alarm[2] = random_range(50, 150);

show_debug_message("start wandering");