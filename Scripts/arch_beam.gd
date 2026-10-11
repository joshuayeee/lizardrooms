extends Area2D

class_name ArchBeam

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
