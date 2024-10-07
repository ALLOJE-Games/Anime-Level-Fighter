function init_goku_baseform() {
	init_charsprites("goku");

	name = "Goku";
	theme = mus_dbfz_goku;

	max_air_moves = 3;
	
	kamehameha_cooldown = 0;
	kamehameha_cooldown_duration = 150;

	kaioken_active = false;
	kaioken_timer = 0;
	kaioken_duration = 10 * 60;
	kaioken_buff = 1.25;
	kaioken_color = make_color_rgb(255,128,128);
	kaioken_min_hp = 100;

	spirit_bomb_shot = noone;

	next_form = obj_goku_ssj;
	transform_aura = spr_aura_dbz_yellow;
	
	add_kiblast_state(
		7,
		spr_goku_special_ki_blast,
		spr_goku_special_ki_blast2,
		spr_kiblast_blue
	);
	
	init_charaudio("goku");
	voice_volume_mine = 1.25;

	char_script = function() {
		kamehameha_cooldown -= 1;
		var _kaioken_active = kaioken_active;
		//if level >= max_level {
		//	kaioken_min_hp = 1;
		//}
		if dead or hp <= kaioken_min_hp {
			kaioken_timer = 0;
		}
		if kaioken_timer-- > 0 {
			kaioken_active = true;
			if kaioken_timer mod ceil(kaioken_duration / (max_hp / 15)) == 0 {
				hp = approach(hp,kaioken_min_hp,1);
			}
			color = kaioken_color;
			aura_sprite = spr_aura_dbz_red;
			loop_sound(snd_energy_loop);
		}
		else {
			kaioken_active = false;
		}
		if kaioken_active != _kaioken_active {
			if kaioken_active {
				attack_power = kaioken_buff;
				move_speed_buff = kaioken_buff;
			}
			else {
				flash_sprite();
				play_sound(snd_energy_stop);
				attack_power = 1;
				move_speed_buff = 1;
				if color == kaioken_color {
					color = c_white;
				}
				aura_sprite = noone;
			}
		}
	}

	//ai_script = function() {
	//	if kaioken_active {
	//		if target_distance < 50 {
	//			ai_input_move(autocombo[0],100);
	//		}
	//		else {
	//			ai_input_move(dash_state,50);
	//		}
	//	}
	//	else {
	//		ai_input_move(kaioken,10);
	//		ai_input_move(spirit_bomb,10);
	//	}
	//	if target_distance < 20 {
	//		ai_input_move(dragon_fist,10);
	//		ai_input_move(meteor_combo,10);
	//		ai_input_move(kiai_push,10);
	//	}
	//	else if target_distance > 200 {
	//		ai_input_move(kiblast,10);
	//		ai_input_move(kamehameha,10);
	//		ai_input_move(super_kamehameha,10);
	//	}
	//}

	light_attack = new state();
	light_attack.start = function() {
		change_sprite(spr_goku_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_attack(2,hiteffects.hit);
	}

	medium_attack = new state();
	medium_attack.start = function() {
		change_sprite(spr_goku_attack_elbow_bash,4,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_attack.run = function() {
		basic_medium_attack(2,hiteffects.hit);
	}

	heavy_attack = new state();
	heavy_attack.start = function() {
		change_sprite(spr_goku_attack_kick_side,5,false);
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_attack.run = function() {
		basic_heavy_attack(2,hiteffects.hit);
	}
	
	light_lowattack = new state();
	light_lowattack.start = function() {
		light_attack.start();
	}
	light_lowattack.run = function() {
		light_attack.run();
	}

	medium_lowattack = new state();
	medium_lowattack.start = function() {
		change_sprite(spr_goku_attack_spin_kick,5,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_lowattack.run = function() {
		basic_medium_lowattack(4,hiteffects.hit);
	}

	heavy_lowattack = new state();
	heavy_lowattack.start = function() {
		change_sprite(spr_goku_attack_backflip_kick,3,false);
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_lowattack.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}
	
	light_airattack = new state();
	light_airattack.start = function() {
		change_sprite(spr_goku_attack_triple_kick_air,2,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}

	medium_airattack = new state();
	medium_airattack.start = function() {
		change_sprite(spr_goku_attack_spin_kick_double,2,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		basic_medium_airattack(4,hiteffects.hit);
		basic_medium_airattack(8,hiteffects.hit);
	}

	heavy_airattack = new state();
	heavy_airattack.start = function() {
		change_sprite(spr_goku_attack_smash,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_airattack.run = function() {
		basic_heavy_airattack(2,hiteffects.hit);
	}

	forward_throw = new state();
	forward_throw.start = function() {
		change_sprite(spr_goku_special_spiritbomb,4,false);
		with(grabbed) {
			change_sprite(grabbed_body_sprite,100,false);
			yoffset = -height / 2;
			depth = other.depth - 1;
		}
		xspeed = 0;
		yspeed = 0;
		play_voiceline(voice_attack);
	}
	forward_throw.run = function() {
		xspeed = 0;
		yspeed = 0;
		grab_frame(0,10,0,0,false);
		grab_frame(1,0,-30,-45,false);
		grab_frame(2,0,-40,-90,false);
		grab_frame(6,-5,-35,-100,false);
		grab_frame(7,-10,-30,-120,false);
		grab_frame(8,-20,-20,-135,false);
		release_grab(9,10,-60,2,30);
		if check_frame(6) {
			play_voiceline(voice_attack);
		}
		return_to_idle();
	}

	back_throw = new state();
	back_throw.start = function() {
		forward_throw.start();
	}
	back_throw.run = function() {
		if check_frame(4) facing = -facing;
		forward_throw.run();
	}

	dragon_fist = new state();
	dragon_fist.start = function() {
		if check_mp(1) {
			change_sprite(spr_goku_attack_punch_gut,8,false);
			activate_super();
			spend_mp(1);
		}
		else {
			change_state(previous_state);
		}
	}
	dragon_fist.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(1) {
			play_sound(snd_punch_whiff_ultimate);
			xspeed = -5 * facing;
		}
		if check_frame(2) {
			xspeed = 0;
		}
		if check_frame(3) {
			xspeed = 20 * facing;
			create_hitbox(0,-height_half,width,height_half,1000,30,-2,attacktype.wall_bounce,attackstrength.super,hiteffects.hit);
		}
		if check_frame(4) {
			xspeed /= 10;
		}
		if (state_timer > 50) {
			return_to_idle();
		}
	}

	kiai_push = new state();
	kiai_push.start = function() {
		if check_mp(1) {
			activate_super();
			spend_mp(1);
			change_sprite(spr_goku_special_ki_blast,3,false);
		}
		else {
			change_state(previous_state)
		}
	}
	kiai_push.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(3) {
			create_particles(
				x+(width_half*facing),
				y-height_half,
				x+(width_half*facing),
				y-height_half,
				shockwave_particle
			);
			create_hitbox(-50,-150,200,200,690,20,-5,attacktype.hard_knockdown,attackstrength.light,hiteffects.none);
		}
		if state_timer > 60 {
			return_to_idle();
		}
	}

	kamehameha_light = new state();
	kamehameha_light.start = function() {
		if kamehameha_cooldown <= 0 {
			change_sprite(spr_goku_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
			}
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration;
			play_voiceline(snd_goku_kamehameha);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(previous_state);
		}
	}
	kamehameha_light.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(6) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(frame,6,9) {
			fire_beam(20,-25,spr_kamehameha,1,0,50);
		}
		return_to_idle();
	}
	
	kamehameha_medium = new state();
	kamehameha_medium.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_medium {
			change_sprite(sprite,frame_duration + 2,false);
		}
	}
	kamehameha_medium.start = function() {
		kamehameha_light.run();
	}
	
	kamehameha_heavy = new state();
	kamehameha_heavy.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_heavy {
			change_sprite(sprite,frame_duration + 3,false);
		}
	}
	kamehameha_heavy.start = function() {
		kamehameha_light.run();
	}

	super_kamehameha = new state();
	super_kamehameha.start = function() {
		if kamehameha_cooldown <= 0 and check_mp(2) {
			change_sprite(spr_goku_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
			}
			activate_super(320);
			spend_mp(2);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
		}
		else {
			change_state(previous_state);
		}
	}
	super_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			if frame > 5 {
				frame = 4;
			}
			if superfreeze_timer == 15 {
				if (input.forward) and check_tp(2) {
					spend_tp(2);
					play_sound(snd_dbz_teleport_long);
					teleport(target_x + ((width + target.width) * facing), target_y);
					face_target();
				
					var _frame = frame;
					change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
					frame = _frame;
				}
			}
		}
		if state_timer <= 120 {
			if frame >= 9 {
				frame = 6;
				frame_timer = 1;
			}
		}
		if value_in_range(frame,6,9) {
			fire_beam(20,-25,spr_kamehameha,2,0,50);
			shake_screen(5,3);
		}
		if check_frame(3) {
			play_voiceline(snd_goku_kamehameha_charge);
			play_sound(snd_dbz_beam_charge_long);
		}
		if check_frame(6) {
			play_voiceline(snd_goku_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
		}
		return_to_idle();
	}

	meteor_combo = new state();
	meteor_combo.start = function() {
		if on_ground and check_mp(1) {
			change_sprite(spr_goku_attack_punch_straight,3,false);
			activate_super();
			spend_mp(1);
		}
		else {
			change_state(previous_state);
		}
	}
	meteor_combo.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if combo_hits > 0 {
			sprite_sequence(
				[
					spr_goku_attack_punch_straight,
					spr_goku_attack_elbow_bash,
					spr_goku_attack_kick_side,
					spr_goku_attack_kick_arc,
					spr_goku_attack_backflip_kick,
					spr_goku_special_kamehameha_air
				],
				frame_duration
			);
		}
		if sprite == spr_goku_special_kamehameha_air {
			if check_frame(1) {
				teleport(target_x - (100 * facing), target_y - 50);
				face_target();
				play_sound(snd_dbz_teleport_short);
			}
			kamehameha.run();
		}
		else {
			if sprite == spr_goku_attack_backflip_kick {
				if check_frame(3) {
					create_hitbox(0,-height,width,height,40,3,-10,attacktype.normal,attackstrength.super,hiteffects.hit);
				}
				if check_frame(2) {
					xspeed = 3 * facing;
					yspeed = -5;
					play_sound(snd_punch_whiff_super);
				}
			}
			else {
				basic_attack(2,40,attackstrength.medium,hiteffects.hit);
				if check_frame(1) {
					xspeed = 10 * facing;
					play_sound(snd_punch_whiff_medium);
				}
			}
		}
		return_to_idle();
	}

	activate_kaioken = new state();
	activate_kaioken.start = function() {
		if check_mp(1) and (!kaioken_timer) and (hp > kaioken_min_hp) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
			color = kaioken_color;
			aura_sprite = spr_aura_dbz_red;
		
			activate_super(100);
			spend_mp(1);
			kaioken_timer = kaioken_duration;
		
			play_sound(snd_energy_start);
			play_voiceline(snd_goku_kaioken);
		}
		else {
			change_state(previous_state);
		}
	}
	activate_kaioken.run = function() {
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}

	spirit_bomb = new state();
	spirit_bomb.start = function() {
		if check_mp(4) and !kaioken_active {
			change_sprite(spr_goku_special_spiritbomb,5,false);
			activate_ultimate();
			spend_mp(4);
			xspeed = 0;
			yspeed = 0;
			x = target_x - 300;
			y = target_y - 200;
		}
		else {
			change_state(previous_state);
		}
	}
	spirit_bomb.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			if frame > 5 {
				frame = 2;
				frame_timer = 1;
			}
		}
		if check_frame(2) {
			spirit_bomb_shot = create_shot(0,-200,0,0,spr_genkidama,2,0,0,0,attacktype.unblockable,attackstrength.ultimate,hiteffects.none)
			with(spirit_bomb_shot) {
				play_sound(snd_activate_super,1,2);
				duration = -1;
				hit_limit = -1;
				active_script = function() {
					if owner.sprite == spr_goku_special_spiritbomb and owner.frame >= 9 {
						xspeed += 1/15 * owner.facing;
						yspeed = abs(xspeed);
					}
					if owner.is_hit {
						duration = 0;
					}
					for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
						if !instance_exists(ds_list_find_value(hitbox.hit_list,i)) {
							with(hitbox) {
								ds_list_delete(hit_list,i--);
							}
						}
					}
					for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
						with(ds_list_find_value(hitbox.hit_list,i)) {
							hitstop = 10;
							x = mean(x,other.x);
							y = mean(y,other.y + height_half);
						}
					}
					x = clamp(x, left_wall, right_wall);
					if y >= ground_height {
						duration = 0;
						for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
							with(ds_list_find_value(hitbox.hit_list,i)) {
								get_hit(other,8000,1,-12,attacktype.hard_knockdown,attackstrength.ultimate,hiteffects.none);
								x = other.x;
								y = ground_height - 1;
								shake_screen(20,5);
							}
						}
						create_particles(x,y,x,y,explosion_large);
					}
				}
			}
		}
		if check_frame(6) {
			play_voiceline(snd_goku_spiritbomb);
		}
		if frame > 11 {
			if instance_exists(spirit_bomb_shot) {
				frame = 10;
			}
		}
		return_to_idle();
	}

	setup_basicmoves();
	
	add_move(kiblast,"D");
	
	add_ground_move(kiai_push,"236D");

	//add_move(dragon_fist,"");
	//add_move(meteor_combo,"EEA");

	add_move(kamehameha_light,"236A");
	add_move(kamehameha_medium,"236B");
	add_move(kamehameha_heavy,"236C");
	
	add_move(super_kamehameha,"214A");
	add_move(super_kamehameha,"214B");
	add_move(super_kamehameha,"214C");
	
	add_ground_move(activate_kaioken,"2D");
	
	add_move(spirit_bomb,"214D");
	
	signature_move = super_kamehameha;
	finisher_move = spirit_bomb;
	
	victory_state.run = function() {
		kaioken_timer = 0;
		if check_frame(4) {
			yspeed = -5;
			squash_stretch(0.9,1.1);
		}
		if on_ground {
			if yspeed > 0 {
				squash_stretch(1.1,0.9);
				yspeed = 0;
				frame = 2;
			}
		}
	}
	
	transform_state.run = function() {
		kaioken_timer = 0;
		aura_sprite = spr_aura_dbz_yellow;
		xspeed = 0;
		yspeed = 0;
		shake_screen(5,2);
		loop_sound(snd_energy_loop);
		if superfreeze_timer <= 5 {
			transform(next_form);
		}
	}

	draw_script = function() {
		if sprite == spr_goku_special_kamehameha
		or sprite == spr_goku_special_kamehameha_air {
			gpu_set_blendmode(bm_add);
			if value_in_range(frame,3,5) {
				var _x = x - (10 * facing);
				var _y = y - 25;
				var _scale = anim_timer / 120;
				draw_sprite_ext(
					spr_kamehameha_charge,
					0,
					_x,
					_y,
					_scale,
					_scale,
					anim_timer * 5,
					c_white,
					1
				);
			}
		}
		gpu_set_blendmode(bm_normal);
	}
}