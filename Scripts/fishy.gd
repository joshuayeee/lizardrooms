extends Enemy

class_name Fishy

@export var stop_point: Node2D = null

@onready var move_com: MoveCom = $Components/MoveCom
@onready var move_timer: Timer = $MoveTimer

@onready var stop_point_y: float = stop_point.global_position.y
@onready var init_point_y: float = global_position.y

enum States {MOVE_UP, MOVE_DOWN, STOP}
var state: States = States.MOVE_UP

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE_UP:
					move_com.handle_vert_move(-1.0)
					
					if (position.y <= stop_point_y):
						state = States.MOVE_DOWN
				States.MOVE_DOWN:
					move_com.handle_vert_move(1.0)
					
					if (position.y >= init_point_y):
						move_timer.start()
						state = States.STOP
				States.STOP:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_move_timer_timeout() -> void:
	state = States.MOVE_UP

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()
