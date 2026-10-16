extends Node

class_name GravityCom

@export var body: CharacterBody2D = null
@export var swim_grav: Vector2 = Vector2.ZERO

func handle_gravity(delta: float) -> void:
	if (not body.is_on_floor()):
		body.velocity += body.get_gravity() * delta

func handle_swim_gravity(delta: float) -> void:
	if (not body.is_on_floor()):
		body.velocity += swim_grav * delta
