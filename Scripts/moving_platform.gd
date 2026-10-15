extends AnimatableBody2D

class_name MovingPlatform

@export var anim_player: AnimationPlayer = null

func _physics_process(_delta: float) -> void:
	if (anim_player != null):
		if (Global.game_active):
			if (not anim_player.is_playing()):
				anim_player.play()
		else:
			if (anim_player.is_playing()):
				anim_player.pause()
