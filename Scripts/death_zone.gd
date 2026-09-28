extends Area2D

class_name DeathZone

func _on_body_entered(body: Player) -> void:
	body.handle_death()
