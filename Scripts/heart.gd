extends CharacterBody2D

class_name Heart

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom

var direction: float = 1.0

func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	move_com.handle_move(direction)
	jump_com.handle_jump(is_on_floor())
	move_and_slide()


func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.collect_heart()
		queue_free()
