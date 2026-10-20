extends CharacterBody2D

class_name Gumball

signal request_destroy()

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		match direction:
			Directions.LEFT:
				move_com.handle_hori_move(-1.0)
			Directions.RIGHT:
				move_com.handle_hori_move(1.0)
		
		jump_com.handle_jump(is_on_floor())
		
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_bottom_check_body_entered(body: Node2D) -> void:
	if (Global.game_active):
		if (body is Player):
			body.hurt()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.LEFT):
		direction = Directions.RIGHT

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.RIGHT):
		direction = Directions.LEFT

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	request_destroy.emit()
