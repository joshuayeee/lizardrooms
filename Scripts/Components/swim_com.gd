extends Node

class_name SwimCom

@export var body: CharacterBody2D = null
@export var swim_velocity: float = 0.0
@export var hori_speed: float = 0.0
@export var max_hori_speed: float = 0.0
@export_range(0.0, 1.0, 0.1) var hori_acc: float = 0.0
@export_range(0.0, 1.0, 0.1) var hori_dec: float = 0.0

@onready var speed: float = hori_speed

func handle_swim(query: bool) -> void:
	if (query):
		body.velocity.y = swim_velocity

func handle_hori_swim(x_dir: float) -> void:
	if x_dir:
		body.velocity.x = move_toward(body.velocity.x, x_dir * speed, speed * hori_acc)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed * hori_dec)

func handle_hori_speed_change(query: bool) -> void:
	if (query):
		speed = max_hori_speed
	else:
		speed = hori_speed
