enum attacktype {
	normal,
	
	unblockable,
	grab,
	antiair,
	
	beam,
	
	hard_knockdown,
	slide_knockdown,
	
	wall_splat,
	wall_bounce,
	ground_bounce,
}

enum attackstrength {
	light,
	medium,
	heavy,
	super,
	ultimate
}

enum hiteffects {
	none,
	
	hit,
	slash,
	pierce,
	
	fire,
	fire_dark,
	
	thunder_blue,
	thunder_yellow,
	thunder_purple,
	
	wind,
	ice,
	water,
	
	dark,
	light,
}

function get_hit(_attacker, _damage, _xknockback, _yknockback, _attacktype, _strength, _hiteffect) {
	var _xspeed = xspeed;
	var _yspeed = yspeed;
	xspeed = _xknockback * _attacker.facing;
	yspeed = _yknockback;
	
	hitstun = map_value(_strength,attackstrength.light,attackstrength.ultimate,15,30);
	blockstun = hitstun - 5;
	hitstop = map_value(_strength,attackstrength.light,attackstrength.ultimate,10,20);
	
	if !is_char(_attacker) {
		hitstop *= 0.5;
		target = _attacker.owner;
	}
	else {
		var _recovery = _attacker.anim_duration - _attacker.anim_timer;
		hitstun = max(hitstun,_recovery);
		blockstun = _recovery - 10;
		target = _attacker;
	}
	
	hitstun = max(hitstun - (combo_hits_taken / 5), 10);
		
	if abs(_xknockback) >= 10
	or abs(_yknockback) >= 10 {
		hitstun = max(hitstun,40);
	}
	
	hitstun = round(hitstun);
	blockstun = round(blockstun);
	hitstop = round(hitstop);
			
	var guarding = is_guarding;
	if is_char(id) {
		if input.back or input.down guarding = true;
		if (ai_enabled) and (random(100) < map_value(ai_level,1,ai_level_max,10,90)) guarding = true;
	}
	
	var guard_valid = (can_guard) and (!is_hit);
	if _attacktype == attacktype.unblockable
	or _attacktype == attacktype.grab {
		guard_valid = false;
	}
	if _attacktype == attacktype.antiair
	and is_airborne {
		guard_valid = false;
	}
	if guard_valid and guarding {
		change_state(guard_state);
		change_sprite(guard_sprite,3,false);
		xspeed *= 2;
		//yspeed /= 2;
		yspeed = _yspeed;
		if on_ground {
			yspeed = 0;
		}
		take_damage(_attacker,_damage/20,false);
	}
	else {
		var connect = true;
		if invincible {
			connect = false;
		}
		if is_shot(_attacker) {
			if immune_to_projectiles {
				connect = false;
			}
		}
		if connect {
			switch(_attacktype) {
				default:
				change_state(hit_state);
				if on_ground and _yknockback >= 0 {
					yspeed = 0;
				}
				else if is_airborne and _yknockback == 0 {
					yspeed = -abs(xspeed) / 2;
				}
				break;
				
				case attacktype.hard_knockdown:
				change_state(hard_knockdown_state);
				break;
				
				case attacktype.wall_bounce:
				if previous_state != wall_bounce_state {
					change_state(wall_bounce_state);
					play_sound(snd_launch);
				}
				else {
					change_state(hit_state);
				}
				hitstun = max(hitstun,100);
				break;
				
				case attacktype.slide_knockdown:
				change_state(slide_knockdown_state);
				break;
				
				case attacktype.grab:
				with(_attacker) {
					init_grab(id,other);
				}
				break;
			}
			
			change_sprite(choose(hit_high_sprite,hit_low_sprite),3,false);
			if is_airborne {
				change_sprite(hit_air_sprite,frame_duration,false);
			}
			if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
				change_sprite(launch_sprite,frame_duration,true);
				yoffset = -height_half;
				rotation = point_direction(0,0,abs(xspeed),-yspeed);
			}
			if yspeed <= -10 {
				change_sprite(spinout_sprite,frame_duration,true);
				yoffset = -height_half;
				rotation = point_direction(0,0,abs(xspeed),-yspeed);
			}
			
			var _hp = hp;
			var dmg = take_damage(_attacker,_damage,!grabbed);
	
			combo_timer = hitstun + 20;
			if active_state == hard_knockdown_state
			or active_state == wall_bounce_state {
				combo_timer += 60;
			}
			
			combo_hits_taken++;
			
			combo_hits = 0;
			combo_damage = 0;
			
			if is_char(_attacker) {
				with(_attacker) {
					combo_timer = other.combo_timer;
					combo_hits++;
					combo_damage += dmg;
				}
			}
			else {
				with(_attacker.owner) {
					combo_timer = other.combo_timer;
					combo_hits++;
					combo_damage += dmg;
				}
			}
			
			if (_hp > 0) {
				if (hp > 0) {
					var _heavyattack_speed = 10;
					var is_heavyattack = ((abs(xspeed) >= _heavyattack_speed) or (abs(yspeed) >= _heavyattack_speed));
					if on_ground and (yspeed > -_heavyattack_speed) {
						is_heavyattack = false;
					}
					if is_heavyattack {
						play_voiceline(voice_hurt_heavy,50,true);
			
						if meme_enabled {
							if random(100) < meme_chance {
								stop_sound(voice);
								voice = play_sound(
									choose(
										snd_meme_scream_disappear,
										snd_meme_scream_disappear_srpelo,
										snd_meme_scream_disappear_vsauce
									),
									3
								);
							}
						}
					}
					else {
						play_voiceline(voice_hurt,50,true);
					}
				}
				else {
					if is_char(id) {
						play_voiceline(voice_dead,100,true);
					}
					if on_ground {
						if yspeed >= 0 {
							yspeed = -5;
							xspeed = 5 * _attacker.facing;
						}
					}
				}
			}
			
			frame = 0;
			frame_timer = 0;
			facing = -_attacker.facing;
		}
		else {
			xspeed = _xspeed;
			yspeed = _yspeed;
		}
	}
	
	if on_wall {
		if is_char(_attacker) or is_helper(_attacker) {
			_attacker.xspeed = xspeed * -0.5;
		}
	}
	
	super_active = false;
	
	depth = 0;
	_attacker.depth = -1;
	if is_char(_attacker) or is_helper(_attacker) {
		_attacker.hitstop = hitstop;
		_attacker.can_cancel = true;
	}
	
	create_hitspark(id,_strength,_hiteffect,guard_valid and guarding);
	apply_hiteffect(_hiteffect,_strength,guard_valid and guarding);
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount);
	
	var defender = id;
	
	var true_attacker = _attacker;
	if instance_exists(true_attacker) {
		while(!is_char(true_attacker)) {
			true_attacker = true_attacker.owner;
		}
	}
	else {
		true_attacker = noone;
		dmg *= 1/4;
		_kill = false;
	}
	
	with(true_attacker) {
		dmg *= attack_power + ((level * level_scaling) + 1);
	}
	
	if is_char(defender){
		dmg *= get_damage_scaling(defender);
		dmg *= get_damage_scaling_guts(defender);
		
		//_kill = defender.level >= 3;
	}
	
	dmg /= max(defender.defense,0.35);
	
	dmg = max(round(dmg),1);
	
	hp -= dmg;
	if !dead {
		if !_kill {
			hp = max(hp,1);
		}
	}
	
	combo_damage_taken += min(dmg,hp-(!_kill));
	
	var mp_gain = map_value(dmg,0,max_hp,0,max_mp);
	var xp_gain = map_value(dmg,0,max_hp,0,max_xp);
	
	var defend_mp_gain = mp_gain * 1.25;
	var defend_xp_gain = xp_gain * 1.05;
	
	var attack_mp_gain = mp_gain * 1.50;
	var attack_xp_gain = xp_gain * 0.10;
	
	if !is_char(_attacker) {
		attack_mp_gain /= 2;
		attack_xp_gain /= 2;
	}
	
	mp += defend_mp_gain;
	xp += defend_xp_gain;
	with(true_attacker) {
		if !super_active {
			mp += attack_mp_gain;
		}
		xp += attack_xp_gain;
	}
	
	return dmg;
}

function get_damage_scaling(_defender) {
	with(_defender) {
		var scaling = map_value(
			combo_damage_taken,
			max_hp * 0.05,
			max_hp * 0.3,
			1,
			0
		);
		scaling = clamp(scaling,0.1,1);
		return scaling;
	}
}

function get_damage_scaling_guts(_defender) {
	with(_defender) {
		var guts = map_value(
			hp+combo_damage_taken,
			max_hp/5,
			0,
			1,
			5
		);
		guts = max(guts,1);
		return 1 / guts;
	}
}

function reset_combo() {
	if combo_hits_taken > 1 {
		show_debug_message("combo hits: " + string(combo_hits_taken));
		show_debug_message("combo damage: " + string(combo_damage_taken));
	}
	combo_hits = 0;
	combo_damage = 0;
	combo_hits_taken = 0;
	combo_damage_taken = 0;
}

function init_clash(_char1, _char2) {
	
}