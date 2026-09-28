extends CharacterBody2D

class_name BoxPiece

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom

var direction: float = 1.0
var can_jump: bool = true

func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	jump_com.handle_jump(can_jump)
	can_jump = false
	move_com.handle_move(direction)
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
