extends Node

class_name GravityCom

@export var body: CharacterBody2D = null

func handle_gravity(delta: float) -> void:
	if (not body.is_on_floor()):
		body.velocity += body.get_gravity() * delta
