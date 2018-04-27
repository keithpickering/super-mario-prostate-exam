///scRestoreHp(amount)

global.show_hp = true;

var amount = argument0;

if (global.hp + amount < global.hp_max) {
	global.hp += amount;
} else {
	global.hp = global.hp_max;
}