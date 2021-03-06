if (!oPlayer.is_invincible) {
	// Decrease HP
	global.hp -= 1;
	global.show_hp = true;

	// Shake camera whenever we get hurt
	oCamera.is_shake = true;
	oCamera.alarm[0] = 20;

	// TODO check if dead and handle that
	if (global.hp == 0) {
		room_restart();
	}
	
	// Cancel fancy jumps
	oPlayer.jump_current = 0;
	if (oPlayer.is_jump > 0) {
		oPlayer.is_jump = 1;
	}

	// Make player invincible temporarily
	oPlayer.is_invincible = true;
	oPlayer.is_hurt = true;
	oPlayer.alarm[0] = 2 * room_speed;
}