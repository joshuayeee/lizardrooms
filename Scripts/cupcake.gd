extends CharacterBody2D

class_name Cupcake

@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var blink_player: AnimationPlayer = $BlinkPlayer
@onready var end_timer: Timer = $EndTimer

var direction: float = 1.0

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		move_com.handle_hori_move(direction)
		jump_com.handle_jump(is_on_floor())
	else:
		velocity = Vector2.ZERO
	
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

func _on_start_blink_timer_timeout() -> void:
	blink_player.play("blink")
	end_timer.start()

func _on_end_timer_timeout() -> void:
	call_deferred("queue_free")
