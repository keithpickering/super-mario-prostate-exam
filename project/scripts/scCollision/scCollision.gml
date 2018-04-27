///scCollision(x,y,hsp,vsp)

var this_x = argument0;
var this_y = argument1;
var this_hsp = argument2;
var this_vsp = argument3;

/**
 * HORIZONTAL COLLISION
 */

if (place_meeting(this_x+this_hsp,this_y,oWall)){
    // Up slope
	var yplus = 0;
    while (place_meeting(this_x + this_hsp, this_y - yplus, oWall)) && (yplus <= abs(this_hsp)) {
		yplus += 1;
	}
	
    if (place_meeting(this_x + this_hsp, this_y - yplus, oWall)){
        while (!place_meeting(this_x + sign(this_hsp), this_y, oWall)) {
			this_x += sign(this_hsp);
		}
        this_hsp = 0;
    } else {
        this_y -= yplus;
    }
}
this_x += this_hsp;

// Down slope
if (!place_meeting(this_x, this_y, oWall)) && (this_vsp >= 0) && (place_meeting(this_x, this_y+2+abs(this_hsp), oWall)) {
    while (!place_meeting(this_x, this_y + 1, oWall)) {
		this_y += 1;
	}
}

/**
 * VERTICAL COLLISION
 */

if (place_meeting(this_x, this_y + this_vsp, oWall)) {
	while (!place_meeting(this_x, this_y + sign(this_vsp), oWall)) {
		this_y += sign(this_vsp);
	}
	this_vsp = 0;
}
this_y += this_vsp;

return [this_x,this_y,this_hsp,this_vsp];