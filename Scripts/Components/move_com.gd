extends Node

class_name MoveCom

@export var body: CharacterBody2D
@export var walk_speed: float = 0.0
@export var run_speed: float = 0.0
@export_range(0.0, 1.0, 0.1) var acc: float = 0.0
@export_range(0.0, 1.0, 0.1) var dec: float = 0.0

@onready var speed: float = walk_speed

func handle_hori_move(x_dir: float) -> void:
	if x_dir:
		body.velocity.x = move_toward(body.velocity.x, x_dir * speed, speed * acc)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed * dec)

func handle_vert_move(y_dir: float) -> void:
	if y_dir:
		body.velocity.y = move_toward(body.velocity.y, y_dir * speed, speed * acc)
	else:
		body.velocity.y = move_toward(body.velocity.y, 0, speed * dec)

func handle_speed_change(query: bool) -> void:
	if (query):
		speed = run_speed
	else:
		speed = walk_speed
