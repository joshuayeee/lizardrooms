extends CandyEnemy

class_name Rip

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = $MoveTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var left_ground_check: Area2D = $LeftGroundCheck
@onready var right_ground_check: Area2D = $RightGroundCheck
@onready var mouthbreaker_point: Node2D = $MouthbreakerPoint

enum States {MOVE, SHOOT}
var state: States = States.MOVE

enum Directions {RIGHT, LEFT}
var direction: Directions = Directions.LEFT

var has_activated: bool = false

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		if (is_active):
			match state:
				States.MOVE:
					match direction:
						Directions.LEFT:
							move_com.handle_hori_move(-1.0)
						Directions.RIGHT:
							move_com.handle_hori_move(1.0)
				States.SHOOT:
					move_com.handle_hori_move(0.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func shoot_mouthbreaker() -> void:
	var mouthbreaker: Mouthbreaker = MOUTHBREAKER.instantiate()
	mouthbreaker.global_position = mouthbreaker_point.global_position
	mouthbreaker.direction = Vector2.UP
	created_mouthbreaker.emit(mouthbreaker)

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.LEFT):
		direction = Directions.RIGHT
		sprite_2d.flip_h = true

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.RIGHT):
		direction = Directions.LEFT
		sprite_2d.flip_h = false

func _on_left_ground_check_body_exited(_body: Node2D) -> void:
	if (not left_ground_check.has_overlapping_bodies()):
		if (direction == Directions.LEFT):
			direction = Directions.RIGHT
			sprite_2d.flip_h = true

func _on_right_ground_check_body_exited(_body: Node2D) -> void:
	if (not right_ground_check.has_overlapping_bodies()):
		if (direction == Directions.RIGHT):
			direction = Directions.LEFT
			sprite_2d.flip_h = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if (not has_activated):
		animation_player.play("move")
		is_active = true
		move_timer.start()
		has_activated = true

func _on_move_timer_timeout() -> void:
	if (state == States.MOVE):
		animation_player.play("shoot")
		shoot_mouthbreaker()
		state = States.SHOOT
		shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	if (state == States.SHOOT):
		animation_player.play("move")
		state = States.MOVE
		move_timer.start()
