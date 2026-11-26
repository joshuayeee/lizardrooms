extends Node

class_name AnimCom

@export var sprite: Sprite2D = null
@export var anim_player: AnimationPlayer = null
@export var move_player: AnimationPlayer = null

@onready var player_state_com: PlayerStateCom = $PlayerStateCom

func handle_animation(direction: float, 
						in_air: bool,
						jump_anim: String,
						walk_anim: String,
						idle_anim: String) -> void:
	if (direction):
		sprite.flip_h = (direction < 0)
	
	if (in_air):
		anim_player.play(jump_anim)
	else:
		if (direction):
			anim_player.play(walk_anim)
		else:
			anim_player.play(idle_anim)

func handle_player_animation(direction: float,
								velo: Vector2,
								in_air: bool,
								jump_anim: String,
								walk_anim: String,
								turn_anim: String,
								idle_anim: String) -> void:
	if (direction):
		sprite.flip_h = (direction < 0)
	
	if (in_air):
		anim_player.play(jump_anim)
	else:
		if (direction):
			if ((direction < 0 and velo.x > 0) or (direction > 0 and velo.x < 0)):
				anim_player.play(turn_anim)
			else:
				anim_player.play(walk_anim)
		else:
			anim_player.play(idle_anim)

func handle_player_swim_animation(direction: float, swim_anim: String, play_swim_query: bool) -> void:
	if (direction):
		sprite.flip_h = (direction < 0)
	
	if (play_swim_query):
		anim_player.play(swim_anim)

func handle_anim_change(old_state: PlayerStateCom.States, 
							new_state: PlayerStateCom.States, 
							norm_sand: String, 
							sand_candy: String, 
							norm_candy: String) -> void:
	match old_state:
		player_state_com.States.NORMAL:
			match new_state:
				player_state_com.States.SANDWICH:
					anim_player.play(norm_sand)
				player_state_com.States.CANDY:
					anim_player.play(norm_candy)
		player_state_com.States.SANDWICH:
			match new_state:
				player_state_com.States.NORMAL:
					anim_player.play(norm_sand)
				player_state_com.States.CANDY:
					anim_player.play(sand_candy)
		player_state_com.States.CANDY:
			match new_state:
				player_state_com.States.NORMAL:
					anim_player.play(norm_candy)
				player_state_com.States.SANDWICH:
					anim_player.play(sand_candy)

func handle_death_anim(death_anim: String, move_anim: String) -> void:
	anim_player.play(death_anim)
	move_player.play(move_anim)

func handle_enter_anim(move_anim: String) -> void:
	move_player.play(move_anim)

func reset_move_player(move_anim: String) -> void:
	move_player.play(move_anim)

func play_idle(anim_name: String) -> void:
	anim_player.play(anim_name)

func play_jump(anim_name: String) -> void:
	anim_player.play(anim_name)
