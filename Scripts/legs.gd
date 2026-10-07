extends Enemy

class_name Legs

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wait_timer: Timer = $WaitTimer

var has_activated: bool = false

var can_jump: bool = false

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var player: Player = null

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		if (is_active):
			if (can_jump):
				jump_com.handle_jump(is_on_floor())
				
				if (player != null):
					if (player.global_position.x > global_position.x):
						direction = Directions.RIGHT
					else:
						direction = Directions.LEFT
				
				can_jump = false
			
			if (not is_on_floor()):
				animation_player.play("jump")
				match direction:
					Directions.LEFT:
						move_com.handle_hori_move(-1.0)
					Directions.RIGHT:
						move_com.handle_hori_move(1.0)
			else:
				animation_player.play("idle")
				move_com.handle_hori_move(0.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if (not has_activated):
		is_active = true
		wait_timer.start()
		has_activated = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_wait_timer_timeout() -> void:
	can_jump = true
	wait_timer.start()
