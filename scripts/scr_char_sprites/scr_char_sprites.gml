// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum grab_point {
	base,
	head,
	body,
	leg
}

enum grab_frames {
	justgrabbed,
	low,
	mid,
	high,
	air,
	launch,
	liedown
}

function init_charsprites(_name) {
	var prefix = "spr_" + _name + "_";
	
	idle_sprite = asset_get_index(prefix + "idle");
	
	crouch_sprite = asset_get_index(prefix + "crouch");
	uncrouch_sprite = asset_get_index(prefix + "uncrouch");
	
	walk_sprite = asset_get_index(prefix + "walk");
	
	jumpsquat_sprite = crouch_sprite;
	
	air_up_sprite = asset_get_index(prefix + "air_up");
	air_peak_sprite = asset_get_index(prefix + "air_peak");
	air_down_sprite = asset_get_index(prefix + "air_down");
	
	dash_sprite = asset_get_index(prefix + "dash");
	
	guard_sprite = asset_get_index(prefix + "guard");
	
	hit_high_sprite = asset_get_index(prefix + "hit_high");
	hit_low_sprite = asset_get_index(prefix + "hit_low");
	hit_air_sprite = asset_get_index(prefix + "hit_air");
	
	launch_sprite = asset_get_index(prefix + "hit_launch");
	spinout_sprite = asset_get_index(prefix + "hit_spinout");
	
	liedown_sprite = asset_get_index(prefix + "liedown");
	wakeup_sprite = asset_get_index(prefix + "wakeup");
	
	tech_sprite = asset_get_index(prefix + "air_recover");
	
	grabbed_sprite[grab_point.base] = asset_get_index(prefix + "grabbed_base");
	grabbed_sprite[grab_point.head] = asset_get_index(prefix + "grabbed_head");
	grabbed_sprite[grab_point.body] = asset_get_index(prefix + "grabbed_body");
	grabbed_sprite[grab_point.leg] = asset_get_index(prefix + "grabbed_leg");
	
	fist_rush_sprite = asset_get_index(prefix + "rush_fist");
	weapon_rush_sprite = asset_get_index(prefix + "rush_weapon");
	
	fist_combat_sprite = asset_get_index(prefix + "combat_fist");
	weapon_combat_sprite = asset_get_index(prefix + "combat_weapon");
	combat_dodge_sprite = crouch_sprite;
	combat_block_sprite = guard_sprite;
	
	fist_bind_sprite = asset_get_index(prefix + "bind_fist");
	weapon_bind_sprite = asset_get_index(prefix + "bind_weapon");
	
	intro_sprite = asset_get_index(prefix + "intro");
	victory_sprite = asset_get_index(prefix + "victory");
	defeat_sprite = asset_get_index(prefix + "defeat");
	
	charge_start_sprite = asset_get_index(prefix + "energy_charge_start");
	charge_loop_sprite = asset_get_index(prefix + "energy_charge_loop");
	charge_stop_sprite = asset_get_index(prefix + "energy_charge_stop");
	
	icon = asset_get_index(prefix + "icon");
	
	init_sprite(idle_sprite);
	
	var _w = max(40,width);
	var _h = max(40,height);
	
	var _head_size = 16;
	
	var _body_w = round(_w * 0.8);
	var _body_h = _h - min(_head_size,round(_h * 0.35));
	
	with(obj_hurtbox) {
		if owner == other {
			instance_destroy();
		}
	}
	
	create_hurtbox(
		-_body_w/2,
		-_body_h,
		_body_w,
		_body_h
	);
	create_hurtbox(
		-_head_size/3,
		-_h,
		_head_size,
		_head_size
	);
}

function update_charsprite() {
	update_sprite();
	
	switch(sprite) {
		case idle_sprite:
		case crouch_sprite:
		case uncrouch_sprite:
		if anim_frames == 1 {
			xstretch += sine_wave(state_timer,100,0.02,0);
			ystretch -= sine_wave(state_timer,100,0.02,0);
		}
		if sprite_get_yoffset(sprite) > sprite_get_height(sprite) {
			yoffset = sine_wave(state_timer,100,2,0);
		}
		break;
	
		case walk_sprite:
		case dash_sprite:
		if sprite_get_yoffset(sprite) > sprite_get_height(sprite) {
			yoffset = sine_wave(anim_timer,anim_duration,2,0);
		}
		break;
	
		case air_up_sprite:
		case air_peak_sprite:
		case air_down_sprite:
		var _stretch = clamp(max(ygravity,abs(yspeed)) / 200,0,0.2);
		xstretch = 1 - _stretch;
		ystretch = 1 + _stretch;
		break;
	
		case launch_sprite:
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
		break;
	
		case spinout_sprite:
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
		if anim_timer mod 15 == 1 {
			create_specialeffect(
				spr_wind_spin,
				x,
				y-height_half,
				1,
				1,
				point_direction(0,0,xspeed,yspeed)
			);
		}
		break;
	}

	if sprite_exists(aura_sprite) {
		aura_frame += sprite_get_speed(aura_sprite) / 60;
		if aura_frame >= sprite_get_number(aura_sprite) {
			aura_frame = 0;
		}
	}
}

function apply_hiteffect(_strength,_hiteffect,_guarding) {
	if !_guarding {
		switch(_hiteffect) {
			case hiteffects.fire:
			flash_sprite(10,make_color_rgb(255,64,0));
			break;
		}
	}
}