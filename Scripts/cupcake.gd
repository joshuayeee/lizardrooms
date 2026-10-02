extends CharacterBody2D

class_name Cupcake

@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var gravity_com: GravityCom = $Components/GravityCom

var direction: float = 1.0

func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	move_com.handle_hori_move(direction)
	jump_com.handle_jump(is_on_floor())
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.collected_cupcake()
		queue_free()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0
