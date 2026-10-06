extends Enemy

class_name Twister

const TWISTER_HEAD = preload("uid://bknuxevadx2oj")

signal created_head(head: TwisterHead)

@onready var move_com: MoveCom = $Components/MoveCom
@onready var stop_timer: Timer = $StopTimer
@onready var move_timer: Timer = $MoveTimer

var x_dir: float = -1.0

enum States {MOVE, STOP}
var state: States = States.MOVE

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE:
					move_com.handle_hori_move(x_dir)
				States.STOP:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func drop_head() -> void:
	var head: TwisterHead = TWISTER_HEAD.instantiate()
	head.global_position = global_position
	created_head.emit(head)

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")

func _on_stop_timer_timeout() -> void:
	move_timer.start()
	state = States.MOVE

func _on_move_timer_timeout() -> void:
	drop_head()
	stop_timer.start()
	state = States.STOP
