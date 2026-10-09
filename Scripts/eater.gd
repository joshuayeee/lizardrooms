extends Enemy

@onready var move_com: MoveCom = $Components/MoveCom
@onready var stop_point: Node2D = $StopPoint
@onready var go_down_timer: Timer = $GoDownTimer
@onready var go_up_timer: Timer = $GoUpTimer

@onready var stop_point_y: float = stop_point.position.y
@onready var init_point_y: float = position.y

enum States {MOVE_UP, STOP, MOVE_DOWN}
var state: States = States.MOVE_UP

var player_above: bool = false

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE_UP:
					move_com.handle_vert_move(-1.0)
					
					if (position.y <= stop_point_y):
						go_down_timer.start()
						state = States.STOP
				States.STOP:
					velocity = Vector2.ZERO
				States.MOVE_DOWN:
					move_com.handle_vert_move(1.0)
					
					if (position.y >= init_point_y):
						go_up_timer.start()
						state = States.STOP
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt() -> void:
	pass

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				body.hurt()
			else:
				poof_death()

func _on_go_up_timer_timeout() -> void:
	if (not player_above):
		state = States.MOVE_UP
	else:
		go_up_timer.start()

func _on_go_down_timer_timeout() -> void:
	state = States.MOVE_DOWN

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_up_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		player_above = true

func _on_up_check_body_exited(body: Node2D) -> void:
	if (body is Player):
		player_above = false
