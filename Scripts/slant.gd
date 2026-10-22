extends Enemy

class_name Slant

@onready var move_com: MoveCom = $Components/MoveCom
@onready var stop_timer: Timer = $StopTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var range_check: Area2D = $RangeCheck

enum States {STOP, DROP, RISE}
var state: States = States.STOP

var can_attack: bool = true

var init_pos: Vector2 = Vector2.ZERO

func _ready():
	is_active = true
	init_pos = global_position

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.STOP:
					velocity = Vector2.ZERO
					
					if (can_attack and range_check.has_overlapping_bodies()):
						state = States.DROP
						can_attack = false
				States.DROP:
					move_com.handle_vert_move(1.0)
				States.RISE:
					if (move_com.handle_move_to(init_pos, delta)):
						global_position = init_pos
						state = States.STOP
						attack_timer.start()
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

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				poof_death()
