extends Area2D

class_name Explosion

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
