extends Boss

class_name Arch

@export var left_point: Node2D = null
@export var right_point: Node2D = null

@onready var move_com: MoveCom = $Components/MoveCom
@onready var timers: Node = $Timers
@onready var hurt_timer: Timer = $Timers/HurtTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var shoot_timer: Timer = $Timers/ShootTimer
@onready var launch_timer: Timer = $Timers/LaunchTimer
@onready var pre_swoop_timer: Timer = $Timers/PreSwoopTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum States {MOVE, CHARGE, SHOOT, SWOOP, PRE_SWOOP, MOVE_TO, MOVE_UP, HURT, DEAD}
var state: States = States.MOVE

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE or States.CHARGE:
					match direction:
						Directions.LEFT:
							move_com.handle_hori_move(-1.0)
						Directions.RIGHT:
							move_com.handle_hori_move(1.0)
				States.MOVE_TO:
					var reached_point: bool = false
					match direction:
						Directions.LEFT:
							reached_point = move_com.handle_move_to(left_point.global_position, delta)
						Directions.RIGHT:
							reached_point = move_com.handle_move_to(right_point.global_position, delta)
					if (reached_point):
						pass
				States.MOVE_UP:
					pass
				States.SWOOP:
					pass
				_:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func start_fight() -> void:
	is_active = true
	handle_move()

func launch_minion() -> void:
	pass

func handle_move() -> void:
	state = States.MOVE
 
func handle_charge() -> void:
	state = States.CHARGE

func handle_shoot() -> void:
	state = States.SHOOT

func handle_move_to() -> void:
	state = States.MOVE_TO

func handle_pre_swoop() -> void:
	state = States.PRE_SWOOP

func handle_swoop() -> void:
	state = States.SWOOP

func handle_move_up() -> void:
	state = States.MOVE_UP

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

func handle_hurt(life_amount: int) -> void:
	state = States.HURT

func handle_jawbreaker_hurt(life_amount: int) -> void:
	pass

func handle_death() -> void:
	state = States.DEAD
