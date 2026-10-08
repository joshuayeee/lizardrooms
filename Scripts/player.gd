extends CharacterBody2D

class_name Player

const JAWBREAKER = preload("uid://bcln7bcxc0shr")

signal player_loses()
signal collected_donut()
signal collected_heart(lives_amount: int)
signal reached_checkpoint(checkpoint_num: int)
signal player_entered(false_wall_exit: FalseWallExit, special_cam_point: SpecialCamPoint)
signal player_returned(false_wall_exit: FalseWallExit)
signal request_layer_change(layer_name: String)
signal reached_door(next_wl: String, next_wt: String, next_name: String, my_state: String, is_bonus: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var anim_com: AnimCom = $Components/AnimCom
@onready var hurt_timer: Timer = $HurtTimer
@onready var blink_player: AnimationPlayer = $BlinkPlayer
@onready var cupcake_timer: Timer = $CupcakeTimer
@onready var end_timer: Timer = $EndTimer

var state: String = "normal"
var can_check_up: bool = true
var can_enter: bool = false
var enter_dir: String = ""
var false_wall_exit: FalseWallExit = null
var special_cam_point: SpecialCamPoint = null
var returning: bool = false
var enter_pos_x: float = 0.0
var enter_pos_y: float = 0.0
var was_hurt: bool = false
var jawbreaker_manager: JawbreakerManager = null
var can_shoot: bool = true
var has_cupcake: bool = false

var inf_cupcake_on: bool = false

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("left", "right")
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		jump_com.handle_jump(Input.is_action_just_pressed("jump") and is_on_floor())
		jump_com.handle_jump_release(Input.is_action_just_released("jump") and velocity.y < 0)
		
		move_com.handle_speed_change(Input.is_action_pressed("run"))
		
		move_com.handle_hori_move(direction)
		
		anim_com.handle_player_animation(direction, 
									velocity,
									not is_on_floor(), 
									"%s_jump" % state, 
									"%s_walk" % state,
									"%s_turn" % state, 
									"%s_idle" % state)
		
		if (state == "candy"):
			if (Input.is_action_just_pressed("run") and can_shoot):
				shoot_jawbreaker()
		
		if (can_enter):
			match enter_dir:
				"up":
					if (Input.is_action_just_pressed("up")):
						enter_false_wall()
				"down":
					if (Input.is_action_just_pressed("down")):
						enter_false_wall()
				"left":
					if (Input.is_action_just_pressed("left")):
						enter_false_wall()
				"right":
					if (Input.is_action_just_pressed("right")):
						enter_false_wall()
	else:
		velocity = Vector2.ZERO
	
	if (is_on_floor() and not can_check_up):
		can_check_up = true
	
	move_and_slide()

func change_state(new_state: String) -> void:
	if (state != new_state):
		Global.game_active = false
		anim_com.handle_anim_change(state,
										new_state,
										"normal_to_sandwich",
										"sandwich_to_candy",
										"normal_to_candy")
		state = new_state

func handle_death() -> void:
	Global.game_active = false
	anim_com.handle_death_anim("death", "death_move")

func reach_checkpoint(checkpoint_num: int) -> void:
	reached_checkpoint.emit(checkpoint_num)

func collect_donut() -> void:
	collected_donut.emit()

func collect_heart(lives_amount: int) -> void:
	collected_heart.emit(lives_amount)

func collected_cupcake() -> void:
	turn_on_cupcake_power()

func enter_false_wall() -> void:
	request_layer_change.emit("back")
	match enter_dir:
		"right":
			global_position.y = enter_pos_y
			anim_com.handle_enter_anim("enter_right")
		"left":
			global_position.y = enter_pos_y
			anim_com.handle_enter_anim("enter_left")
		"up":
			global_position.x = enter_pos_x
			anim_com.handle_enter_anim("enter_up")
		"down":
			global_position.x = enter_pos_x
			anim_com.handle_enter_anim("enter_down")
	Global.game_active = false

func hurt() -> void:
	if (state == "normal"):
		handle_death()
	else:
		was_hurt = true
		change_state("normal")

func turn_on_hurt_invincible() -> void:
	set_collision_layer_value(2, false)
	set_collision_layer_value(1, true)
	blink_player.play("blink")
	hurt_timer.start()

func turn_on_cupcake_power() -> void:
	set_collision_layer_value(2, false)
	set_collision_layer_value(13, true)
	blink_player.play("blink")
	has_cupcake = true
	cupcake_timer.start()

func turn_off_hurt_invincible() -> void:
	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)
	blink_player.play("normal")

func turn_off_cupcake_power() -> void:
	set_collision_layer_value(2, true)
	set_collision_layer_value(13, false)
	blink_player.play("normal")
	has_cupcake = false

func shoot_jawbreaker() -> void:
	if (jawbreaker_manager != null):
		var jawbreaker: Jawbreaker = JAWBREAKER.instantiate()
		jawbreaker.global_position = global_position
		
		if (sprite_2d.flip_h):
			jawbreaker.x_dir = -1.0
		else:
			jawbreaker.x_dir = 1.0
			
		jawbreaker.destroyed.connect(jawbreaker_destroyed)
		jawbreaker_manager.add_child(jawbreaker)
		can_shoot = false

func jawbreaker_destroyed() -> void:
	can_shoot = true

func got_to_door(next_wl: String,
					next_wt: String,
					next_name: String,
					is_bonus: bool) -> void:
	Global.game_active = false
	end_timer.start()
	await end_timer.timeout
	reached_door.emit(next_wl, next_wt, next_name, state, is_bonus)

func _on_up_check_body_entered(body: Node2D) -> void:
	if (can_check_up):
		if (body.has_method("player_hit")):
			body.player_hit(self)
			can_check_up = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "normal_to_sandwich" or
		anim_name == "sandwich_to_candy" or 
		anim_name == "normal_to_candy"):
			Global.game_active = true
			
			if (was_hurt):
				turn_on_hurt_invincible()
				was_hurt = false

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "death_move"):
		player_loses.emit()
	elif (anim_name == "enter_left" or anim_name == "enter_right" or anim_name == "enter_up" or anim_name == "enter_down"):
		if (returning):
			player_returned.emit(false_wall_exit)
		else:
			player_entered.emit(false_wall_exit, special_cam_point)
		anim_com.reset_move_player("idle")

func _on_down_check_body_entered(body: Node2D) -> void:
	if (body is Enemy):
		if (body is Friend):
			if (not is_on_floor() and velocity.y > 0 and body.is_active):
				if (not body.is_fake_dead):
					jump_com.handle_jump(true)
				body.hurt()
		else:
			if (not is_on_floor() and velocity.y > 0 and body.is_active):
				jump_com.handle_jump(true)
				body.hurt()
	elif (body is Boss):
		if (not is_on_floor() and velocity.y > 0 and body.is_active):
			if (body.handle_hit("stomp")):
				jump_com.handle_jump(true)

func _on_hurt_timer_timeout() -> void:
	turn_off_hurt_invincible()

func _on_cupcake_timer_timeout() -> void:
	turn_off_cupcake_power()

func turn_on_inf_cupcake_power() -> void:
	set_collision_layer_value(2, false)
	set_collision_layer_value(13, true)
	has_cupcake = true

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("debug_cupcake")):
		if (inf_cupcake_on):
			turn_off_cupcake_power()
			print("inf off")
			inf_cupcake_on = false
		else:
			turn_on_inf_cupcake_power()
			print("inf on")
			inf_cupcake_on = true
