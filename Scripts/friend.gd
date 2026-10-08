extends SmartEnemy

class_name Friend

@onready var move_com: MoveCom = $Components/MoveCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var wait_timer: Timer = $WaitTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var fake_death_timer: Timer = $FakeDeathTimer
@onready var player_check: Area2D = $PlayerCheck

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var can_jump: bool = false

var is_fake_dead: bool = false

var has_activated: bool = false

var my_body: Player = null

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		if (is_active):
			if (not is_fake_dead):
				if (my_body != null):
					handle_player_check()
				
				if (can_jump and is_on_floor()):
					jump_com.handle_jump(true)
					
					if (player != null):
						if (player.global_position.x > global_position.x):
							direction = Directions.RIGHT
						else:
							direction = Directions.LEFT
						sprite_2d.flip_h = (direction == Directions.RIGHT)
					
					can_jump = false
					wait_timer.start()
				
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
				animation_player.play("fake_death")
				move_com.handle_hori_move(0.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func hurt():
	if (not is_fake_dead):
		is_fake_dead = true
		fake_death_timer.start()
		wait_timer.stop()

func _on_wait_timer_timeout() -> void:
	can_jump = true

func handle_player_check() -> void:
	if (Global.game_active and is_active and not my_body.has_cupcake):
		my_body.hurt()
		my_body = null
	elif (my_body.has_cupcake):
		poof_death()

func _on_fake_death_timer_timeout() -> void:
	is_fake_dead = false
	wait_timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if (not has_activated):
		is_active = true
		wait_timer.start()
		has_activated = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		my_body = body

func _on_player_check_body_exited(body: Node2D) -> void:
	if (body is Player):
		my_body = null
