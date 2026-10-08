extends Boss

class_name Fluores

const BOLT = preload("uid://bufqwdlisucju")

signal created_bolt(bolt: Bolt)

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var timers: Node = $Timers
@onready var init_disappear_timer: Timer = $Timers/InitDisappearTimer
@onready var disappear_timer: Timer = $Timers/DisappearTimer
@onready var move_timer: Timer = $Timers/MoveTimer
@onready var appear_timer: Timer = $Timers/AppearTimer
@onready var shock_timer: Timer = $Timers/ShockTimer
@onready var hurt_timer: Timer = $Timers/HurtTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

enum States {INIT_DISAPPEAR, DISAPPEAR, APPEAR, SHOCK, HURT, MOVE, DEAD}
var state: States = States.DISAPPEAR

enum Directions {RIGHT, LEFT}
var direction: Directions = Directions.LEFT

enum ShockDirections {LEFT, RIGHT, UP, UP_RIGHT, UP_LEFT}

var is_vulnerable: bool = false
var can_attack: bool = false

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
				_:
					move_com.handle_hori_move(0.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func start_fight() -> void:
	is_active = true
	handle_disappear()

func handle_hit(attack_type: String) -> bool:
	var success: bool = false
	if (is_vulnerable):
		success = true
		match attack_type:
			"stomp":
				handle_hurt(4)
			"jawbreaker":
				handle_jawbreaker_hurt(1)
	return success

func shock_attack() -> void:
	for dir: ShockDirections in ShockDirections.values():
		var bolt: Bolt = BOLT.instantiate()
		bolt.global_position = global_position
		match dir:
			ShockDirections.LEFT:
				bolt.direction = Vector2.LEFT
			ShockDirections.RIGHT:
				bolt.direction = Vector2.RIGHT
			ShockDirections.UP:
				bolt.direction = Vector2.UP
			ShockDirections.UP_RIGHT:
				bolt.direction = Vector2(1.0, -0.5)
			ShockDirections.UP_LEFT:
				bolt.direction = Vector2(-1.0, -0.5)
		created_bolt.emit(bolt)

func teleport_to_player() -> void:
	if (player != null):
		global_position.x = player.global_position.x

func handle_appear() -> void:
	state = States.APPEAR
	animation_player.play("appear")
	sprite_2d.visible = true
	is_vulnerable = false
	can_attack = false
	teleport_to_player()
	appear_timer.start()

func handle_shock() -> void:
	state = States.SHOCK
	animation_player.play("shock")
	is_vulnerable = true
	can_attack = true
	shock_attack()
	shock_timer.start()

func handle_move() -> void:
	state = States.MOVE
	animation_player.play("electric_move")
	is_vulnerable = false
	can_attack = true
	move_timer.start()

func handle_init_disappear() -> void:
	state = States.INIT_DISAPPEAR
	animation_player.play("appear")
	is_vulnerable = false
	can_attack = false
	init_disappear_timer.start()

func handle_disappear() -> void:
	state = States.DISAPPEAR
	sprite_2d.visible = false
	is_vulnerable = false
	can_attack = false
	disappear_timer.start()

func handle_hurt(lives_amount: int) -> void:
	stop_timers()
	lives -= lives_amount
	if (lives > 0):
		state = States.HURT
		animation_player.play("hurt")
		is_vulnerable = false
		can_attack = false
		hurt_timer.start()
	else:
		handle_death()

func handle_jawbreaker_hurt(lives_amount: int) -> void:
	lives -= lives_amount
	if (lives <= 0):
		handle_death()

func handle_death() -> void:
	stop_timers()
	state = States.DEAD
	animation_player.play("death")
	is_vulnerable = false
	can_attack = false
	death_timer.start()

func end_fight() -> void:
	lost_fight.emit()
	call_deferred("queue_free")

func stop_timers() -> void:
	for child in timers.get_children():
		if (child is Timer):
			child.stop()

func _on_disappear_timer_timeout() -> void:
	if (state == States.DISAPPEAR):
		handle_appear()

func _on_appear_timer_timeout() -> void:
	if (state == States.APPEAR):
		handle_shock()

func _on_shock_timer_timeout() -> void:
	if (state == States.SHOCK):
		handle_move()

func _on_move_timer_timeout() -> void:
	if (state == States.MOVE):
		handle_init_disappear()

func _on_hurt_timer_timeout() -> void:
	if (state == States.HURT):
		handle_move()

func _on_death_timer_timeout() -> void:
	end_fight()

func _on_init_disappear_timer_timeout() -> void:
	if (state == States.INIT_DISAPPEAR):
		handle_disappear()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.LEFT):
		direction = Directions.RIGHT
		sprite_2d.flip_h = true

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.RIGHT):
		direction = Directions.LEFT
		sprite_2d.flip_h = false

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (can_attack):
					body.hurt()
			else:
				handle_death()
