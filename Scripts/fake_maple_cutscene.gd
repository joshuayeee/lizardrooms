extends Sprite2D

class_name FakeMapleCutscene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_player: AnimationPlayer = $MovePlayer

func play_anim(anim_name: String) -> void:
	animation_player.play(anim_name)

func play_move_anim(anim_name: String) -> void:
	move_player.play(anim_name)

func set_facing_right(query: bool) -> void:
	flip_h = query
