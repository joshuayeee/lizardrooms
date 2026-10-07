extends Enemy

class_name Sweed

const MOUTHBREAKER = preload("uid://dasp4lmbyhkdn")

signal created_mouthbreaker (mouthbreaker: Mouthbreaker)

@export var stop_point: Node2D = null

@onready var go_up_timer: Timer = $GoUpTimer
@onready var go_down_timer: Timer = $GoDownTimer
@onready var move_com: MoveCom = $Components/MoveCom
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var stop_point_y: float = stop_point.global_position.y
@onready var init_point_y: float = position.y

enum States {MOVING_UP, MOVING_DOWN, STOP}
var state: States = States.MOVING_UP

var player: Player = null

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			
			if (player != null):
				sprite_2d.flip_h = (player.global_position.x > global_position.x)
			
			match state:
				States.MOVING_UP:
					move_com.handle_vert_move(-1.0)
					
					if (position.y <= stop_point_y):
						shoot_mouthbreaker()
						go_down_timer.start()
						state = States.STOP
				States.STOP:
					velocity = Vector2.ZERO
				States.MOVING_DOWN:
					move_com.handle_vert_move(1.0)
					
					if (position.y >= init_point_y):
						go_up_timer.start()
						state = States.STOP
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func shoot_mouthbreaker() -> void:
	if (player != null):
		var mouthbreaker: Mouthbreaker = MOUTHBREAKER.instantiate()
		mouthbreaker.global_position = global_position
		mouthbreaker.direction = (player.global_position - global_position).normalized()
		created_mouthbreaker.emit(mouthbreaker)

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_go_up_timer_timeout() -> void:
	state = States.MOVING_UP

func _on_go_down_timer_timeout() -> void:
	state = States.MOVING_DOWN

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_active = false
