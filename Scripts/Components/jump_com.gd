extends Node

class_name JumpCom

@export var body: CharacterBody2D = null
@export var jump_velocity: float = 0.0
@export_range(0.0, 1.0, 0.1) var jump_release_dec: float = 0.0

func handle_jump(query: bool) -> void:
	if (query):
		body.velocity.y = jump_velocity

func handle_jump_release(query: bool) -> void:
	if (query):
		body.velocity.y *= jump_release_dec
