randomize();

function change_gamestate(_gamestate, _wait = 0) {
	next_game_state = _gamestate;
	game_state_timer = min(game_state_timer,screen_fade_duration);
	game_state_duration = _wait + (screen_fade_duration*2);
}

function update_fight() {
	round_state_timer += 1;
	var _roundstate = round_state;
	if round_state == roundstates.intro {
		var ready = round_state_timer > 60;
		with(obj_char) {
			if active_state != idle_state { ready = false; }
			if sound_is_playing(voice) { ready = false; }
			if state_timer < 60 { ready = false; }
		}
		if ready {
			round_state = roundstates.countdown;
		}
	}
	else if round_state == roundstates.countdown {
		if round_state_timer >= round_countdown_duration {
			round_state = roundstates.fight;
		}
	}
	else if round_state == roundstates.fight {
		round_timer -= 1;
		if round_timer <= 0 {
			round_state = roundstates.time_over;
		}
		
		var alldead = instance_number(obj_char) - instance_number(obj_helper);
		with(obj_char) {
			if !dead {
				alldead -= is_char(id);
			}
		}
		if alldead {
			round_state = roundstates.knockout;
			play_sound(snd_round_end_knockout);
		}
	}
	else if round_state == roundstates.time_over or round_state == roundstates.knockout {
		var ready = round_state_timer > 60;
		with(obj_char) {
			if dead {
				if active_state != liedown_state { ready = false; }
			}
			else {
				if active_state != idle_state { ready = false; }
			}
			if state_timer < 60 { ready = false; }
		}
		if ready {
			round_state = roundstates.victory;
		}
	}
	else if round_state == roundstates.victory {
		var team1_score = get_team_score(1);
		var team2_score = get_team_score(2);
		var ready = round_state_timer > 60;
		with(obj_char) {
			if active_state == idle_state {
				if (team == 1 and (team1_score > team2_score))
				or (team == 2 and (team2_score > team1_score)) {
					change_state(victory_state);
				}
				else {
					change_state(defeat_state);
				}
			}
			if !anim_finished { ready = false; }
			if sound_is_playing(voice) { ready = false; }
			if state_timer < 60 { ready = false; }
		}
		if ready {
			if next_game_state == -1 {
				change_gamestate(game_state+1);
				if next_game_state == gamestates.training + 1 {
					change_gamestate(gamestates.training);
				}
			}
		}
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
	
	var border = 16;
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if (!dead) and (!is_helper(id)) {
			_x1 = min(_x1,x);
			_y1 = min(_y1,y);
			_x2 = max(_x2,x);
			_y2 = max(_y2,y);
		}
	}
	battle_x = mean(_x1,_x2);
	battle_y = mean(_y1,_y2);
	var battle_size = game_width + 100;
	left_wall = clamp(battle_x - (battle_size / 2),0,room_width-game_width) + border;
	right_wall = clamp(battle_x + (battle_size / 2),game_width,room_width) - border;
	
	if superfreeze_timer > 0 {
		superfreeze_active = true;
		superfreeze_timer -= 1;
	}
	else {
		superfreeze_active = false;
		superfreeze_activator = noone;
		superfreeze_timer = 0;
	}
	
	if timestop_timer > 0 {
		timestop_active = true;
		timestop_timer -= 1;
	}
	else {
		timestop_active = false;
		timestop_activator = noone;
		timestop_timer = 0;
	}
}