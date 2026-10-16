extends SmartEnemy

class_name OctoOcto

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var swim_com: SwimCom = $Components/SwimCom
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var charge_timer: Timer = $ChargeTimer
@onready var death_timer: Timer = $DeathTimer

enum TimeModes {MIN, MAX}
var time_mode: TimeModes = TimeModes.MAX

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var has_activated: bool = false

var can_swim: bool = true

func _physics_process(delta: float) -> void:
	if (Global.game_active and is_active):
		gravity_com.handle_swim_gravity(delta)
		
		if (player != null):
			if (can_swim):
				if (player.global_position.y <= global_position.y):
					swim()
					can_swim = false
					charge_timer.start()
				
			if (player.global_position.x > global_position.x):
				direction = Directions.RIGHT
			else:
				direction = Directions.LEFT
		
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt() -> bool:
	return false

func swim() -> void:
	animation_player.play("swim")
	
	swim_com.handle_hori_swim(0.0)
		
	swim_com.handle_swim(true)
		
	match direction:
		Directions.LEFT:
			swim_com.handle_hori_swim(-1.0)
		Directions.RIGHT:
			swim_com.handle_hori_swim(1.0)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true
	
	death_timer.stop()

func _on_charge_timer_timeout() -> void:
	can_swim = true

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				poof_death()

func _on_death_timer_timeout() -> void:
	poof_death()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if (is_active):
		death_timer.start()
