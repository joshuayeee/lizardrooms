extends StaticBody2D

class_name Fence

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
