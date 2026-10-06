extends Node

class_name AnimCom

@export var sprite: Sprite2D = null
@export var anim_player: AnimationPlayer = null
@export var move_player: AnimationPlayer = null

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

func handle_anim_change(old_state, 
							new_state, 
							norm_sand, 
							sand_candy, 
							norm_candy) -> void:
	match old_state:
		"normal":
			match new_state:
				"sandwich":
					anim_player.play(norm_sand)
				"candy":
					anim_player.play(norm_candy)
		"sandwich":
			match new_state:
				"normal":
					anim_player.play(norm_sand)
				"candy":
					anim_player.play(sand_candy)
		"candy":
			match new_state:
				"normal":
					anim_player.play(norm_candy)
				"sandwich":
					anim_player.play(sand_candy)

func handle_death_anim(death_anim: String, move_anim: String) -> void:
	anim_player.play(death_anim)
	move_player.play(move_anim)

func handle_enter_anim(move_anim: String) -> void:
	move_player.play(move_anim)

func reset_move_player(move_anim: String) -> void:
	move_player.play(move_anim)

func play_idle(move_anim: String) -> void:
	anim_player.play(move_anim)
