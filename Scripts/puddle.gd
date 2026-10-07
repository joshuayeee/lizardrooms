extends Enemy

class_name Puddle

const MOUTHBREAKER = preload("uid://dasp4lmbyhkdn")

signal created_mouthbreaker(mouthbreaker: Mouthbreaker)

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

var player: Player = null

enum Directions {RIGHT, LEFT}
var direction: Directions = Directions.LEFT

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		if (is_active):
			if (player != null):
				if (player.position.x > position.x):
					direction = Directions.RIGHT
					sprite_2d.flip_h = true
				else:
					direction = Directions.LEFT
					sprite_2d.flip_h = false
	
	move_and_slide()

func shoot_mouthbreaker() -> void:
	if (player != null and is_active):
		var mouthbreaker: Mouthbreaker = MOUTHBREAKER.instantiate()
		mouthbreaker.global_position = poof_point.global_position
		mouthbreaker.direction = (player.global_position - global_position).normalized()
		created_mouthbreaker.emit(mouthbreaker)

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	shoot_timer.start()
	is_active = true

func _on_shoot_timer_timeout() -> void:
	shoot_mouthbreaker()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_active = false
