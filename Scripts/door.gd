extends Area2D

class_name Door

@export var is_bonus: bool = false

@export var next_world_level: String = ""
@export var next_world_title: String = ""
@export var next_level_name: String = ""

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.got_to_door(next_world_level, next_world_title, next_level_name, is_bonus)
