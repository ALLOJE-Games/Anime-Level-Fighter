// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_kiblast(_x,_y,_sprite) {
	with(create_shot(
		_x,
		_y,
		20,
		random_range(-2,2),
		_sprite,
		30 / sprite_get_height(_sprite),
		20,
		3,
		-3,
		attacktype.normal,
		attackstrength.light,
		hiteffects.fire
	)) {
		blend = true;
		hit_script = function() {
			create_particles(x,y,x,y,explosion_small);
		}
		active_script = function() {
			if y >= ground_height {
				hit_script();
				instance_destroy();
			}
		}
	}
	play_sound(snd_kiblast_fire);
}