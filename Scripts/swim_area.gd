extends Area2D

class_name SwimArea

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.set_move_mode(body.MoveModes.SWIM)

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		body.set_move_mode(body.MoveModes.NORMAL)
