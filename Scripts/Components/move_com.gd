extends Node

class_name MoveCom

@export var body: CharacterBody2D
@export var walk_speed: float = 0.0
@export var run_speed: float = 0.0
@export var angular_speed: float = 0.0
@export_range(0.0, 1.0, 0.1) var acc: float = 1.0
@export_range(0.0, 1.0, 0.1) var dec: float = 1.0
@export_range(0.0, 1.0, 0.01) var max_acc: float = 1.0

@onready var speed: float = walk_speed

var angle: float = 0.0

func handle_hori_move(x_dir: float) -> void:
	if x_dir:
		if (body.is_on_floor()):
			if ((x_dir < 0 and body.velocity.x > 0) or (x_dir > 0 and body.velocity.x < 0)):
				body.velocity.x = move_toward(body.velocity.x, x_dir * speed, speed * max_acc)
			else:
				body.velocity.x = move_toward(body.velocity.x, x_dir * speed, speed * acc)
		else:
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

func handle_move_towards(direction: Vector2) -> void:
	body.velocity = direction * speed

func handle_move_to(pos: Vector2, delta: float) -> bool:
	var distance: float = body.global_position.distance_to(pos)
	
	if (distance <= speed * delta):
		body.velocity = Vector2.ZERO
		return true
	else:
		body.velocity = (pos - body.global_position).normalized() * speed
		return false

func set_angle(new_angle: float) -> void:
	angle = new_angle

func handle_orbit_move(center: Node2D, radius: float, delta: float) -> void:
	_handle_angle_calc(delta)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * radius
	body.global_position = center.global_position + offset

func handle_orbit_move_to(center: Node2D, radius: float, delta: float, end_angle: float, direction: float) -> bool:
	var remaining: float = 0.0
	
	if direction > 1.0:
		remaining = fposmod(end_angle - angle, TAU)
	else:
		remaining = fposmod(angle - end_angle, TAU)
	
	var angle_step: float = angular_speed * delta
	
	if remaining <= angle_step:
		angle = end_angle
		body.global_position = center.global_position + Vector2.RIGHT.rotated(angle) * radius
		return true
	else:
		angle = fposmod(angle + direction * angle_step, TAU)
		body.global_position = center.global_position + Vector2.RIGHT.rotated(angle) * radius
		return false

func _handle_angle_calc(delta: float)  -> void:
	angle = fposmod(angle + (angular_speed * delta), TAU)
