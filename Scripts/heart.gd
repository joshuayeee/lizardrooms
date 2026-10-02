extends CharacterBody2D

class_name Heart

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom

var direction: float = 1.0
var can_move: bool = true
var lives: int = 1

func _ready() -> void:
	match lives:
		2:
			animation_player.play("two_lives")
		3:
			animation_player.play("three_lives")
		_:
			animation_player.play("one_life")
			lives = 1


func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	if (can_move):
		move_com.handle_hori_move(direction)
		jump_com.handle_jump(is_on_floor())
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.collect_heart(lives)
		queue_free()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0
