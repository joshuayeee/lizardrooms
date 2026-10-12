extends Boss

class_name Arch

const ARCH_MINION = preload("uid://cowpjn45esq5u")
const ARCH_BEAM = preload("uid://b7658yoqmpnem")
const ARCH_BULLET = preload("uid://dimy6hpey178v")

signal created_bullet(bullet: ArchBullet)

@export var far_left_point: Node2D = null
@export var far_right_point: Node2D = null
@export var mid_right_point: Node2D = null
@export var mid_left_point: Node2D
@export var top_up_point: Node2D = null
@export var bot_up_point: Node2D = null
@export var top_left_minion_point: Node2D = null
@export var bot_left_minion_point: Node2D = null
@export var top_right_minion_point: Node2D = null
@export var bot_right_minion_point: Node2D = null
@export var min_roam_time: float = 1.0
@export var max_roam_time: float = 3.0

@onready var move_com: MoveCom = $Components/MoveCom
@onready var timers: Node = $Timers
@onready var roam_timer: Timer = $Timers/RoamTimer
@onready var charge_timer: Timer = $Timers/ChargeTimer
@onready var hurt_timer: Timer = $Timers/HurtTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var pre_swoop_timer: Timer = $Timers/PreSwoopTimer
@onready var shoot_timer: Timer = $Timers/ShootTimer
@onready var reset_timer: Timer = $Timers/ResetTimer
@onready var launch_timer: Timer = $Timers/LaunchTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum States {ROAM, CHARGE, SHOOT, SWOOP, PRE_SWOOP, MOVE_TO, MOVE_UP, RESET, MOVE_DOWN, HURT, DEAD}
var state: States = States.RESET

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var swoop_amount: int = 3

var minions: Array[ArchMinion] = []
var minion_amount: int = 9

var beam: ArchBeam = null

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match state:
				States.ROAM:
					var reached_point: bool = false
					match direction:
						Directions.LEFT:
							reached_point = move_com.handle_move_to(far_left_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.RIGHT
						Directions.RIGHT:
							reached_point = move_com.handle_move_to(far_right_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.LEFT
				States.CHARGE:
					var reached_point: bool = false
					match direction:
						Directions.LEFT:
							reached_point = move_com.handle_move_to(far_left_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.RIGHT
						Directions.RIGHT:
							reached_point = move_com.handle_move_to(far_right_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.LEFT
				States.SHOOT:
					var reached_point: bool = false
					match direction:
						Directions.LEFT:
							reached_point = move_com.handle_move_to(far_left_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.RIGHT
						Directions.RIGHT:
							reached_point = move_com.handle_move_to(far_right_point.global_position, delta)
							
							if (reached_point):
								direction = Directions.LEFT
				States.MOVE_TO:
					var reached_point: bool = false
					match direction:
						Directions.LEFT:
							reached_point = move_com.handle_move_to(mid_left_point.global_position, delta)
						Directions.RIGHT:
							reached_point = move_com.handle_move_to(mid_right_point.global_position, delta)
					if (reached_point):
						handle_pre_swoop()
				States.MOVE_UP:
					var reached_point: bool = false
					var pos: Vector2 = Vector2(global_position.x, top_up_point.global_position.y)
					reached_point = move_com.handle_move_to(pos, delta)
					if (reached_point):
						handle_reset()
				States.MOVE_DOWN:
					var reached_point: bool = false
					var pos: Vector2 = Vector2(global_position.x, bot_up_point.global_position.y)
					reached_point = move_com.handle_move_to(pos, delta)
					if (reached_point):
						handle_roam()
				States.SWOOP:
					var reached_point: bool = false
					match direction:
						Directions.RIGHT:
							reached_point = move_com.handle_orbit_move_to(bot_up_point, global_position.distance_to(bot_up_point.global_position), delta, PI, 1.0)
							
							if (reached_point):
								swoop_amount -= 1
								if (swoop_amount > 0):
									direction = Directions.LEFT
									handle_pre_swoop()
								else:
									handle_move_up()
						Directions.LEFT:
							reached_point = move_com.handle_orbit_move_to(bot_up_point, global_position.distance_to(bot_up_point.global_position), delta, 0, -1.0)
							
							if (reached_point):
								swoop_amount -= 1
								if (swoop_amount > 0):
									direction = Directions.RIGHT
									handle_pre_swoop()
								else:
									handle_move_up()
				_:
					velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func start_fight() -> void:
	is_active = true
	handle_reset()

func create_minions() -> void:
	for i: int in range(minion_amount):
		var minion: ArchMinion = ARCH_MINION.instantiate()
		minion.destroyed.connect(remove_minion)
		minion.center = self
		minion.angle = TAU * float(i) / float(minion_amount)
		minion.top_left_point = top_left_minion_point.global_position
		minion.bot_left_point = bot_left_minion_point.global_position
		minion.top_right_point = top_right_minion_point.global_position
		minion.bot_right_point = bot_right_minion_point.global_position
		created_enemy.emit(minion)
		minions.append(minion)

func launch_minion() -> void:
	randomize()
	if (not minions.is_empty()):
		var rand_num: int = randi_range(0, len(minions) - 1)
		var minion: ArchMinion = minions[rand_num]
		if (minion.state == minion.States.ORBIT):
			var num: int = randi_range(0, 100)
			if (num <= 50):
				minion.start_launch(global_position, "right")
			else:
				minion.start_launch(global_position, "left")
		launch_timer.start()
	else:
		stop_timers()
		handle_move_to()

func remove_all_minions() -> void:
	for minion in minions.duplicate():
		remove_minion(minion)

func remove_minion(minion: ArchMinion) -> void:
	var i: int = minions.find(minion)
	if (i != -1):
		minions.pop_at(i)
		minion.poof_death()

func shoot_beam() -> void:
	beam = ARCH_BEAM.instantiate()
	add_child(beam)

func remove_beam() -> void:
	if (beam != null):
		beam.call_deferred("queue_free")

func fire_spreadshot() -> void:
	var dir: Vector2 = (player.global_position - global_position).normalized()
	
	var spread_angle: float = deg_to_rad(20.0)
	
	var angles: Array[float] = [
		-spread_angle,
		0.0,
		spread_angle
	]
	
	for angle in angles:
		var bullet: ArchBullet = ARCH_BULLET.instantiate()
		bullet.global_position = global_position
		bullet.direction = dir.rotated(angle)
		created_bullet.emit(bullet)
	

func end_fight() -> void:
	lost_fight.emit()
	call_deferred("queue_free")

func handle_roam() -> void:
	state = States.ROAM
	is_vulnerable = true
	can_attack = true
	animation_player.play("idle")
	remove_beam()
	launch_timer.start()
	
	roam_timer.wait_time = randf_range(min_roam_time, max_roam_time)
	
	roam_timer.start()
 
func handle_charge() -> void:
	state = States.CHARGE
	is_vulnerable = true
	can_attack = true
	animation_player.play("charge")
	charge_timer.start()

func handle_shoot() -> void:
	state = States.SHOOT
	is_vulnerable = true
	can_attack = true
	animation_player.play("idle")
	shoot_beam()
	shoot_timer.start()

func handle_move_to() -> void:
	state = States.MOVE_TO
	is_vulnerable = true
	can_attack = true
	remove_beam()
	animation_player.play("idle")

func handle_pre_swoop() -> void:
	state = States.PRE_SWOOP
	is_vulnerable = true
	can_attack = true
	animation_player.play("idle")
	fire_spreadshot()
	pre_swoop_timer.start()

func handle_swoop() -> void:
	state = States.SWOOP
	is_vulnerable = true
	can_attack = true
	animation_player.play("idle")
	
	match direction:
		Directions.LEFT:
			move_com.set_angle(PI)
		Directions.RIGHT:
			move_com.set_angle(0)

func handle_move_up() -> void:
	state = States.MOVE_UP
	is_vulnerable = false
	can_attack = false
	animation_player.play("idle")

func handle_reset() -> void:
	state = States.RESET
	is_vulnerable = false
	can_attack = false
	animation_player.play("idle")
	swoop_amount = 3
	create_minions()
	reset_timer.start()

func handle_move_down() -> void:
	state = States.MOVE_DOWN
	is_vulnerable = false
	can_attack = true
	animation_player.play("idle")

func handle_hit(attack_type: String) -> bool:
	var success: bool = false
	
	if (is_vulnerable):
		match attack_type:
			"stomp":
				handle_hurt(2)
				success = true
			"jawbreaker":
				handle_jawbreaker_hurt(1)
				success = true
			_:
				success = false
	else:
		success = false
	
	return success

func handle_hurt(life_amount: int) -> void:
	lives -= life_amount
	
	if (lives > 0):
		state = States.HURT
		remove_all_minions()
		is_vulnerable = false
		can_attack = false
		animation_player.play("hurt")
		hurt_timer.start()
	else:
		handle_death()

func handle_jawbreaker_hurt(life_amount: int) -> void:
	lives -= life_amount
	
	if (lives <= 0):
		handle_death()

func handle_death() -> void:
	stop_timers()
	state = States.DEAD
	remove_all_minions()
	is_vulnerable = false
	can_attack = false
	animation_player.play("death")
	death_timer.start()

func stop_timers() -> void:
	for child in timers.get_children():
		if (child is Timer):
			child.stop()

func _on_launch_timer_timeout() -> void:
	launch_minion()

func _on_hurt_timer_timeout() -> void:
	handle_move_up()

func _on_death_timer_timeout() -> void:
	end_fight()

func _on_shoot_timer_timeout() -> void:
	handle_roam()

func _on_pre_swoop_timer_timeout() -> void:
	handle_swoop()

func _on_roam_timer_timeout() -> void:
	handle_charge()

func _on_charge_timer_timeout() -> void:
	handle_shoot()

func _on_reset_timer_timeout() -> void:
	handle_move_down()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				handle_death()
