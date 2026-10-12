extends Enemy

class_name ArchMinion

signal destroyed(arch_minion: ArchMinion)

@export var center: Node2D = null
@export var radius: float = 64.0

@onready var move_com: MoveCom = $Components/MoveCom

enum States {ORBIT, LAUNCH}
var state: States = States.ORBIT

enum LaunchStates {MOVE_TOP, MOVE_BOT, MOVE_HORI}
var launch_state: LaunchStates = LaunchStates.MOVE_TOP

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var angle: float = 0.0

var top_left_point: Vector2 = Vector2.ZERO
var top_right_point: Vector2 = Vector2.ZERO
var bot_left_point: Vector2 = Vector2.ZERO
var bot_right_point: Vector2 = Vector2.ZERO

func _ready() -> void:
	is_active = true
	
	move_com.set_angle(angle)

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.ORBIT:
					if (center != null):
						move_com.handle_orbit_move(center, radius, delta)
				States.LAUNCH:
					match direction:
						Directions.LEFT:
							match launch_state:
								LaunchStates.MOVE_TOP:
									if (move_com.handle_move_to(top_left_point, delta)):
										launch_state = LaunchStates.MOVE_BOT
								LaunchStates.MOVE_BOT:
									if (move_com.handle_move_to(bot_left_point, delta)):
										launch_state = LaunchStates.MOVE_HORI
								LaunchStates.MOVE_HORI:
									move_com.handle_hori_move(1.0)
						Directions.RIGHT:
							match launch_state:
								LaunchStates.MOVE_TOP:
									if (move_com.handle_move_to(top_right_point, delta)):
										launch_state = LaunchStates.MOVE_BOT
								LaunchStates.MOVE_BOT:
									if (move_com.handle_move_to(bot_right_point, delta)):
										launch_state = LaunchStates.MOVE_HORI
								LaunchStates.MOVE_HORI:
									move_com.handle_hori_move(-1.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func start_launch(start_pos: Vector2, dir: String) -> void:
	global_position = start_pos
	
	match dir:
		"right":
			direction = Directions.RIGHT
		_:
			direction = Directions.LEFT
	
	state = States.LAUNCH

func hurt() -> void:
	destroyed.emit(self)

func hit_by_jawbreaker() -> void:
	destroyed.emit(self)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if (state == States.LAUNCH and launch_state == LaunchStates.MOVE_HORI):
		destroyed.emit(self)

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				destroyed.emit(self)
