extends Enemy

class_name Slant

@onready var move_com: MoveCom = $Components/MoveCom
@onready var cool_down_timer: Timer = $CoolDownTimer
@onready var stop_timer: Timer = $StopTimer
@onready var range_check: Area2D = $RangeCheck

@onready var init_y: float = global_position.y

enum States {STOP, DROP, RISE}
var state: States = States.STOP

var can_attack: bool = true

func _ready():
	is_active = true

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.STOP:
					velocity = Vector2.ZERO
					
					if (can_attack and range_check.has_overlapping_bodies()):
						state = States.DROP
						can_attack = false
						cool_down_timer.start()
				States.DROP:
					move_com.handle_vert_move(1.0)
				States.RISE:
					move_com.handle_vert_move(-1.0)
					
					if (global_position.y <= init_y):
						state = States.STOP
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_bottom_check_body_entered(_body: Node2D) -> void:
	if (state == States.DROP):
		state = States.STOP
		stop_timer.start()

func _on_stop_timer_timeout() -> void:
	if (state == States.STOP):
		state = States.RISE

func _on_cool_down_timer_timeout() -> void:
	can_attack = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()
