/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("genos");

theme = mus_genos;

dropkick_cooldown = 0;
dropkick_cooldown_duration = 100;

char_script = function() {
	if active_state != dropkick {
		dropkick_cooldown -= 1;
	}
}

var i = 0;
autocombo[i] = new state();
autocombo[i].start = function() {
	if previous_state == dash_state
	or previous_state == airdash_state
	or previous_state == air_backdash_state {
		if previous_state == air_backdash_state {
			facing = -facing;
		}
		change_state(dash_attack);
	}
	else {
		if on_ground {
			change_sprite(spr_genos_jab,3,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(autocombo[4]);
		}
	}
}
autocombo[i].run = function() {
	standard_attack(2,10,attacktype.light,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_uppercut,4,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,20,attacktype.medium,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick2,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,30,attacktype.medium,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick,6,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	standard_launcher(1,50,hiteffects.punch);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_jab,3,false);
	play_sound(snd_punch_whiff_light2);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,20,attacktype.light,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_uppercut,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,30,attacktype.medium,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(1,40,attacktype.medium,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick2,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,50,attacktype.medium,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_dunk,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
autocombo[i].run = function() {
	standard_smash(2,100,hiteffects.punch);
}
i++;

forward_throw = new state();
forward_throw.start = function() {
	change_sprite(spr_genos_uppercut,8,false);
	with(grabbed) {
		change_sprite(grabbed_head_sprite,1000,false);
		yoffset = -40;
		depth = other.depth + 1;
	}
	xspeed = 0;
	yspeed = 0;
}
forward_throw.run = function() {
	xspeed = 0;
	yspeed = 0;
	if state_timer < 20 {
		frame = 0;
		frame_timer = 0;
	}
	grab_frame(0,10,0,0,false);
	if check_frame(1) {
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,100,true);
	}
	if check_frame(2) {
		var _hit = grabbed;
		release_grab(0,20,0,0,0);
		with(_hit) {
			get_hit(other,attacktype.launcher,50,hiteffects.punch,hitanims.normal);
		}
	}
	if anim_finished {
		change_state(idle_state);
	}
}

back_throw = new state();
back_throw.start = function() {
	forward_throw.start();
}
back_throw.run = function() {
	if check_frame(1) facing = -facing;
	forward_throw.run();
}

dash_attack = new state();
dash_attack.start = function() {
	change_sprite(spr_genos_flyingkick,5,false);
	xspeed = dash_speed * facing;
	yspeed = 0;
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
dash_attack.run = function() {
	xspeed = dash_speed * facing;
	yspeed = 0;
	standard_attack(2,10,attacktype.light,hiteffects.punch);
	standard_attack(3,20,attacktype.medium,hiteffects.punch);
	standard_attack(4,50,attacktype.wall_bounce,hiteffects.punch);
	if anim_finished {
		change_state(idle_state);
	}
}

dropkick = new state();
dropkick.start = function() {
	if dropkick_cooldown <= 0 {
		change_sprite(spr_genos_dropkick,3,false);
		xspeed = 5 * facing;
		yspeed = -10;
		dropkick_cooldown = dropkick_cooldown_duration;
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,100,true);
	}
	else {
		change_state(previous_state);
	}
}
dropkick.run = function() {
	if frame < 5 {
		xspeed = 5 * facing;
		yspeed = -10;
	}
	else if frame >= 6 {
		xspeed = 0;
		yspeed = 30;
	}
	if (frame >= 8) and (frame_timer >= frame_duration - 1) {
		 frame -= 1;
		 frame_timer = 0;
	}
	standard_smash(7,100,hiteffects.punch);
	standard_smash(8,100,hiteffects.punch);
	if on_ground {
		with(create_shot(0,0,5,0,spr_explosion_floor,100,attacktype.launcher,hiteffects.fire)) {
			hit_limit = -1;
			duration = anim_duration;
		}
		with(create_shot(0,0,-5,0,spr_explosion_floor,100,attacktype.launcher,hiteffects.fire)) {
			hit_limit = -1;
			duration = anim_duration;
		}
		play_sound(snd_explosion,1,1.5);
		land();
	}
}

fireshot = new state();
fireshot.start = function() {
	change_sprite(spr_genos_blast,5,false);
}
fireshot.run = function() {
	if check_frame(2) {
		with(create_shot(40,-40,15,0,spr_fireball_small,50,attacktype.wall_splat,hitanims.normal)) {
			blend = true;
			play_sound(snd_kiblast_fire,1,0.8);
			hit_script = function() {
				create_particles(x,y,x,y,explosion_medium);
			}
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

fireshot_up = new state();
fireshot_up.start = function() {
	change_sprite(spr_genos_blast_up,5,false);
}
fireshot_up.run = function() {
	if check_frame(2) {
		with(create_shot(15,-50,5,-15,spr_fireball_small,50,attacktype.wall_bounce,hitanims.normal)) {
			blend = true;
			play_sound(snd_kiblast_fire,1,0.8);
			hit_script = function() {
				create_particles(x,y,x,y,explosion_medium);
			}
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

fireshot_down = new state();
fireshot_down.start = function() {
	change_sprite(spr_genos_blast_down,5,false);
}
fireshot_down.run = function() {
	if check_frame(2) {
		with(create_shot(15,-10,5,15,spr_fireball_small,50,attacktype.smash,hitanims.normal)) {
			blend = true;
			hit_limit = -1;
			active_script = function() {
				if on_ground {
					with(create_shot(0,0,1,0,spr_explosion_floor,50,attacktype.launcher,hitanims.normal)) {
						duration = anim_duration;
						hit_limit = -1;
						play_sound(snd_explosion,1,2);
					}
					duration = 0;
				}
			}
			play_sound(snd_kiblast_fire,1,0.8);
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

incinerate = new state();
incinerate.start = function() {
	if check_mp(2) {
		change_sprite(spr_genos_incinerate,5,false);
		superfreeze();
		spend_mp(2);
		xspeed = 0;
		yspeed = 0;
		play_sound(snd_activate_super);
		play_voiceline(snd_genos_incinerate);
	}
	else {
		change_state(previous_state);
	}
}
incinerate.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame >= 4 {
			frame = 4;
			frame_timer = 0;
		}
	}
	if state_timer <= 120 {
		if frame >= 6 {
			frame = 5;
			frame_timer = 1;
		}
	}
	if state_timer <= 150 {
		if frame >= anim_frames - 1 {
			frame -= 1;
			frame_timer = 0;
		}
	}
	if check_frame(5) {
		play_sound(snd_kamehameha_fire);
	}
	if value_in_range(frame,5,6) {
		fire_beam_attack(10,-30,20,spr_incinerate_beam,attacktype.beam,hiteffects.fire);
	}
	if anim_finished {
		change_state(idle_state);
	}
}
incinerate.stop = function() {
	deactivate_super();
}

super_incinerate = new state();
super_incinerate.start = function() {
	if check_mp(3) {
		change_sprite(spr_genos_incinerate2,5,false);
		superfreeze();
		spend_mp(3);
		xspeed = 0;
		yspeed = 0;
		play_sound(snd_activate_super);
		play_voiceline(snd_genos_incinerate);
	}
	else {
		change_state(previous_state);
	}
}
super_incinerate.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame >= 4 {
			frame = 4;
			frame_timer = 0;
		}
	}
	if state_timer <= 120 {
		if frame >= 6 {
			frame = 5;
			frame_timer = 1;
		}
	}
	if state_timer <= 150 {
		if frame >= anim_frames - 1 {
			frame -= 1;
			frame_timer = 0;
		}
	}
	if check_frame(5) {
		play_sound(snd_kamehameha_fire,1,0.9);
	}
	if value_in_range(frame,5,6) {
		fire_beam_attack(10,-30,20,spr_incinerate2_beam,attacktype.beam,hiteffects.fire);
	}
	if anim_finished {
		change_state(idle_state);
	}
}
super_incinerate.stop = function() {
	deactivate_super();
}

assist_a_state = new state();
assist_a_state.start = function() {
	change_sprite(air_down_sprite,6,false);
	face_target();
	x -= (50 * facing);
}
assist_a_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_genos_blast,3,false);
		}
	}
	else {
		fireshot.run();
	}
}
assist_a_state.stop = function() {
	fireshot.stop();
}

assist_b_state = new state();
assist_b_state.start = function() {
	change_sprite(air_down_sprite,6,false);
	face_target();
	x = target_x - (50 * facing);
}
assist_b_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_genos_flyingkick,3,false);
		}
	}
	else {
		dash_attack.run();
	}
}

assist_c_state = new state();
assist_c_state.start = function() {
	x += (20 * facing);
}
assist_c_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_genos_incinerate,5,false);
		}
	}
	else {
		incinerate.run();
		if state_timer > 60 {
			change_state(tag_out_state);
		}
	}
}

max_air_moves = 3;

setup_autocombo();
add_move(dropkick,"D");
add_move(fireshot,"B");
add_move(fireshot_up,"4B");
add_move(fireshot_down,"2B");
add_move(incinerate,"236B");
add_move(incinerate,"214B");
add_move(super_incinerate,"41236B");
add_move(super_incinerate,"63214B");

ai_script = function() {
	if target_distance < 100 {
		ai_input_move(dropkick,10);
	}
	if target_distance > 150 {
		ai_input_move(fireshot,1);
		ai_input_move(incinerate,10);
		ai_input_move(super_incinerate,10);
	}
}

var i = 0;
voice_attack[i++] = snd_genos_attack1;
voice_attack[i++] = snd_genos_attack2;
voice_attack[i++] = snd_genos_attack3;
i = 0;
voice_heavyattack[i++] = snd_genos_heavyattack1;
voice_heavyattack[i++] = snd_genos_heavyattack2;
i = 0;
voice_chase[i++] = snd_genos_letsgo;
voice_chase[i++] = snd_genos_tooslow;
i = 0;
voice_retreat[i++] = snd_genos_tooslow;
i = 0;
voice_hurt[i++] = snd_genos_hurt1;
voice_hurt[i++] = snd_genos_hurt2;
voice_hurt[i++] = snd_genos_hurt3;
i = 0;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy1;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy2;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy3;
i = 0;
voice_grabbed[i++] = snd_genos_grabbed1;

draw_script = function() {
	if sprite == spr_genos_blast {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(24,rotation*facing) * facing);
			var _y = y - 40;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_blast_up {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(16,rotation*facing) * facing);
			var _y = y - 45;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				(rotation+45)*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_blast_down {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(24,rotation*facing) * facing);
			var _y = y - 24;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				(rotation-45)*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_incinerate {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,5,6) {
			var _x = x + (10 * facing);
			var _y = y - 30;
			var _scale = (frame_timer + 1) / (frame_duration / 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
			draw_sprite_ext(
				spr_incinerate_origin,
				frame mod 2,
				_x,
				_y,
				facing,
				1,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_incinerate2 {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,5,6) {
			var _x = x + (15 * facing);
			var _y = y - 30;
			var _scale = (frame_timer + 1) / (frame_duration / 2);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
			draw_sprite_ext(
				spr_incinerate2_origin,
				frame mod 2,
				_x,
				_y,
				facing,
				1,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	gpu_set_blendmode(bm_normal);
}