extends Area2D

class_name DeathZone

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.handle_death()
	else:
		body.call_deferred("queue_free")
