extends CharacterBody2D

class_name BookBall

@export var center: StaticBody2D = null

@onready var move_com: MoveCom = $Components/MoveCom

var radius: float = 0.0

func _ready() -> void:
	move_com.set_angle(center.global_position.angle_to_point(global_position))
	radius = global_position.distance_to(center.global_position)

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		move_com.handle_orbit_move(center, radius, delta)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
