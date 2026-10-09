extends Enemy

class_name LessieMinion

const FIRE = preload("uid://da5db7w0c728u")

@export var top_point: Node2D = null
@export var bot_point: Node2D = null

@onready var move_com: MoveCom = $Components/MoveCom
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var left_fire_point: Node2D = $LeftFirePoint
@onready var right_fire_point: Node2D = $RightFirePoint

enum States {MOVE_UP, STOP, MOVE_DOWN}
var state: States = States.MOVE_UP

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var fire: Fire = null

func _ready() -> void:
	is_active = true
	
	animation_player.play("move")
	
	match direction:
		Directions.LEFT:
			sprite_2d.flip_h = false
		Directions.RIGHT:
			sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.MOVE_UP:
					if (move_com.handle_move_to(top_point.global_position, delta)):
						animation_player.play("charge")
						state = States.STOP
				States.MOVE_DOWN:
					if (move_com.handle_move_to(bot_point.global_position, delta)):
						state = States.STOP
						handle_destroy()
				_:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func handle_destroy() -> void:
	call_deferred("queue_free")

func handle_connections(lessie_fired: Signal, lessie_stopped: Signal, lessie_hit: Signal) -> void:
	lessie_fired.connect(handle_fire)
	lessie_stopped.connect(handle_stop_fire)
	lessie_hit.connect(poof_death)

func handle_fire() -> void:
	animation_player.play("fire")
	fire = FIRE.instantiate()
	match direction:
		Directions.LEFT:
			fire.position = left_fire_point.position
		Directions.RIGHT:
			fire.position = right_fire_point.position
			fire.direction = fire.Directions.RIGHT
	add_child(fire)

func handle_stop_fire() -> void:
	state = States.MOVE_DOWN
	if (fire != null):
		fire.call_deferred("queue_free")
		fire = null
	animation_player.play("move")

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				body.hurt()
			else:
				poof_death()
