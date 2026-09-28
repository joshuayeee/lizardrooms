extends Area2D

class_name Checkpoint

@export var spawn_point: Marker2D = null
var my_num: int = 0

func _on_body_entered(body: Player) -> void:
	body.reached_checkpoint(my_num)
