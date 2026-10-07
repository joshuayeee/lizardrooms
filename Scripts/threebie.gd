extends Enemy

class_name Threebie

const THREEBIE_HEAD = preload("uid://bwjyi3y7vaqqb")

signal created_head(head: ThreebieHead)

@onready var move_com: MoveCom = $Components/MoveCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_timer: Timer = $MoveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var normal_col: CollisionShape2D = $NormalCol
@onready var headless_col: CollisionShape2D = $HeadlessCol
@onready var player_normal_check: CollisionShape2D = $PlayerCheck/PlayerNormalCheck
@onready var player_headless_check: CollisionShape2D = $PlayerCheck/PlayerHeadlessCheck
@onready var head_start_point: Node2D = $HeadStartPoint

var has_activated: bool = false

enum States {MOVE, HEADLESS}
var state: States = States.MOVE

enum Directions {RIGHT, LEFT}
var direction: Directions = Directions.LEFT

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
				States.HEADLESS:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func launch_head() -> void:
	normal_col.disabled = true
	player_normal_check.disabled = true
	headless_col.disabled = false
	player_headless_check.disabled = false
	animation_player.play("headless")
	
	var head: ThreebieHead = THREEBIE_HEAD.instantiate()
	head.global_position = head_start_point.global_position
	match direction:
		Directions.RIGHT:
			head.direction = head.Directions.RIGHT
		Directions.LEFT:
			head.direction = head.Directions.LEFT
	created_head.emit(head)

func handle_head_return() -> void:
	normal_col.disabled = false
	player_normal_check.disabled = false
	headless_col.disabled = true
	player_headless_check.disabled = true
	animation_player.play("move")
	state = States.MOVE
	move_timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if (not has_activated):
		move_timer.start()
		is_active = true
		has_activated = true

func _on_move_timer_timeout() -> void:
	state = States.HEADLESS
	launch_head()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.LEFT):
		direction = Directions.RIGHT

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.RIGHT):
		direction = Directions.LEFT


func _on_head_check_body_entered(body: Node2D) -> void:
	if (body is ThreebieHead):
		if (body.point == body.Points.FINAL):
			body.call_deferred("queue_free")
			handle_head_return()
