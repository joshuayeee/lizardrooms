extends Boss

class_name Lessie

const LESSIE_MINION = preload("uid://cclqgavtswpaa")

signal shot_fire()
signal stop_fire()

@export var left_top_point: Node2D = null
@export var left_mid_point: Node2D = null
@export var left_bot_point: Node2D = null
@export var right_top_point: Node2D = null
@export var right_mid_point: Node2D = null
@export var right_bot_point: Node2D = null

@export var left_min_bot_point: Node2D = null
@export var left_min_top_point: Node2D = null
@export var mid_min_bot_point: Node2D = null
@export var mid_min_top_point: Node2D = null
@export var right_min_bot_point: Node2D = null
@export var right_min_top_point: Node2D = null

@onready var move_com: MoveCom = $Components/MoveCom
@onready var timers: Node = $Timers
@onready var hurt_timer: Timer = $Timers/HurtTimer
@onready var weak_fire_timer: Timer = $Timers/WeakFireTimer
@onready var strong_fire_timer: Timer = $Timers/StrongFireTimer
@onready var short_charge_timer: Timer = $Timers/ShortChargeTimer
@onready var long_charge_timer: Timer = $Timers/LongChargeTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

enum States {MOVE_TOP, MOVE_MID, MOVE_BOT, HURT, WEAK_FIRE, STRONG_FIRE, SHORT_CHARGE, LONG_CHARGE, DEAD, SWITCH}
var state: States = States.MOVE_TOP

enum Sides {LEFT, RIGHT}
var side: Sides = Sides.LEFT

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE_TOP:
					var reached_point: bool = false
					match side:
						Sides.LEFT:
							reached_point = move_com.handle_move_to(left_top_point.global_position, delta)
						Sides.RIGHT:
							reached_point = move_com.handle_move_to(right_top_point.global_position, delta)
					if (reached_point):
						handle_short_charge()
				States.MOVE_MID:
					var reached_point: bool = false
					match side:
						Sides.LEFT:
							reached_point = move_com.handle_move_to(left_mid_point.global_position, delta)
						Sides.RIGHT:
							reached_point = move_com.handle_move_to(right_mid_point.global_position, delta)
					if (reached_point):
						handle_long_charge()
				States.MOVE_BOT:
					var reached_point: bool = false
					match side:
						Sides.LEFT:
							reached_point = move_com.handle_move_to(left_bot_point.global_position, delta)
						Sides.RIGHT:
							reached_point = move_com.handle_move_to(right_bot_point.global_position, delta)
					if (reached_point):
						switch_sides()
				_:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func start_fight() -> void:
	is_active = true
	handle_move_top()

func switch_sides() -> void:
	state = States.SWITCH
	match side:
		Sides.LEFT:
			global_position = right_bot_point.global_position
			side = Sides.RIGHT
			sprite_2d.flip_h = false
		Sides.RIGHT:
			global_position = left_bot_point.global_position
			side = Sides.LEFT
			sprite_2d.flip_h = true
	handle_move_top()

func spawn_minions() -> void:
	var mid_min: LessieMinion = LESSIE_MINION.instantiate()
	mid_min.global_position = mid_min_bot_point.global_position
	mid_min.bot_point = mid_min_bot_point
	mid_min.top_point = mid_min_top_point
	mid_min.handle_connections(shot_fire, stop_fire)
	
	match side:
		Sides.LEFT:
			var right_min: LessieMinion = LESSIE_MINION.instantiate()
			right_min.bot_point = right_min_bot_point
			right_min.top_point = right_min_top_point
			right_min.global_position = right_min_bot_point.global_position
			right_min.handle_connections(shot_fire, stop_fire)
			right_min.direction = right_min.Directions.RIGHT
			
			mid_min.direction = mid_min.Directions.RIGHT
			
			created_enemy.emit(right_min)
		Sides.RIGHT:
			var left_min: LessieMinion = LESSIE_MINION.instantiate()
			left_min.bot_point = left_min_bot_point
			left_min.top_point = left_min_top_point
			left_min.global_position = left_min_bot_point.global_position
			left_min.handle_connections(shot_fire, stop_fire)
			left_min.direction = left_min.Directions.LEFT
			
			mid_min.direction = mid_min.Directions.LEFT
			
			created_enemy.emit(left_min)
	created_enemy.emit(mid_min)

func shoot_weak_fire() -> void:
	pass

func shoot_strong_fire() -> void:
	pass

func handle_move_top() -> void:
	state = States.MOVE_TOP
	is_vulnerable = false
	can_attack = true
	animation_player.play("move")

func handle_move_mid() -> void:
	state = States.MOVE_MID
	is_vulnerable = false
	can_attack = true
	spawn_minions()
	animation_player.play("move")

func handle_move_bot() -> void:
	state = States.MOVE_BOT
	is_vulnerable = false
	can_attack = true
	stop_fire.emit()
	animation_player.play("move")

func handle_hit(attack_type: String) -> bool:
	var success: bool = false
	
	if (is_vulnerable):
		match attack_type:
			"stomp":
				handle_hurt(2)
				success = true
			"jawbreaker":
				handle_jawbreaker_hurt(1)
				success = true
			_:
				success = false
	else:
		success = false
	
	return success

func handle_hurt(lives_amount: int) -> void:
	stop_timers()
	lives -= lives_amount
	
	if (lives > 0):
		state = States.HURT
		is_vulnerable = false
		can_attack = false
		animation_player.play("hurt")
		hurt_timer.start()
	else:
		handle_death()

func handle_jawbreaker_hurt(lives_amount: int) -> void:
	lives -= lives_amount
	
	if (lives <= 0):
		handle_death()

func handle_weak_fire() -> void:
	state = States.WEAK_FIRE
	is_vulnerable = false
	can_attack = true
	animation_player.play("fire")
	weak_fire_timer.start()

func handle_strong_fire() -> void:
	state = States.STRONG_FIRE
	is_vulnerable = false
	can_attack = true
	animation_player.play("fire")
	shot_fire.emit()
	strong_fire_timer.start()

func handle_short_charge() -> void:
	state = States.SHORT_CHARGE
	is_vulnerable = false
	can_attack = true
	animation_player.play("charge")
	short_charge_timer.start()

func handle_long_charge() -> void:
	state = States.LONG_CHARGE
	is_vulnerable = true
	can_attack = true
	animation_player.play("charge")
	long_charge_timer.start()

func handle_death() -> void:
	stop_timers()
	state = States.DEAD
	is_vulnerable = false
	can_attack = false
	animation_player.play("death")
	death_timer.start()

func end_fight() -> void:
	lost_fight.emit()

func stop_timers() -> void:
	for timer in timers.get_children():
		if (timer is Timer):
			timer.stop()

func _on_hurt_timer_timeout() -> void:
	if (state == States.HURT):
		handle_move_bot()

func _on_weak_fire_timer_timeout() -> void:
	if (state == States.WEAK_FIRE):
		handle_move_mid()

func _on_strong_fire_timer_timeout() -> void:
	if (state == States.STRONG_FIRE):
		handle_move_bot()

func _on_short_charge_timer_timeout() -> void:
	if (state == States.SHORT_CHARGE):
		handle_weak_fire()

func _on_long_charge_timer_timeout() -> void:
	if (state == States.LONG_CHARGE):
		handle_strong_fire()

func _on_death_timer_timeout() -> void:
	if (state == States.DEAD):
		end_fight()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				body.hurt()
			else:
				handle_death()
