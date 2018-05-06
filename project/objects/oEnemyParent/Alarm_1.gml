/// @description Start wandering

// Randomly start moving either left or right
timer_wander = 0;
move = choose(-1, 1);
// Stop moving after a few steps
alarm[2] = random_range(50, 150);