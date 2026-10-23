extends Enemy

@onready var move_com: MoveCom = $Components/MoveCom
@onready var stop_point: Node2D = $StopPoint
@onready var go_down_timer: Timer = $GoDownTimer
@onready var go_up_timer: Timer = $GoUpTimer

@onready var init_stop_point: Vector2 = stop_point.global_position
@onready var init_point: Vector2 = global_position

enum States {MOVE_TO_STOP, STOP, MOVE_TO_INIT}
var state: States = States.MOVE_TO_STOP

var player_above: bool = false

func _ready() -> void:
	is_active = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE_TO_STOP:
					if (move_com.handle_move_to(init_stop_point, delta)):
						go_down_timer.start()
						state = States.STOP
				States.STOP:
					velocity = Vector2.ZERO
				States.MOVE_TO_INIT:
					if (move_com.handle_move_to(init_point, delta)):
						go_up_timer.start()
						state = States.STOP
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt() -> bool:
	return false

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				poof_death()

func _on_go_up_timer_timeout() -> void:
	if (not player_above):
		state = States.MOVE_TO_STOP
	else:
		go_up_timer.start()

func _on_go_down_timer_timeout() -> void:
	state = States.MOVE_TO_INIT

func _on_up_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		player_above = true

func _on_up_check_body_exited(body: Node2D) -> void:
	if (body is Player):
		player_above = false
