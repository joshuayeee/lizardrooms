extends CharacterBody2D

class_name Player

signal player_loses()
signal collected_donut()
signal reached_checkpoint(checkpoint_num: int)
signal player_entered(false_wall_exit: FalseWallExit, special_cam_point: SpecialCamPoint)
signal player_returned(false_wall_exit: FalseWallExit)

@onready var move_com: MoveCom = $Components/MoveCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var anim_com: AnimCom = $Components/AnimCom

var state: String = "normal"
var can_check_up: bool = true
var is_alive: bool = true
var is_changing: bool = false
var is_entering: bool = false
var can_enter: bool = false
var enter_dir: String = ""
var false_wall_exit: FalseWallExit = null
var special_cam_point: SpecialCamPoint = null
var returning: bool = false

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("left", "right")
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		jump_com.handle_jump(Input.is_action_just_pressed("jump") and is_on_floor())
		jump_com.handle_jump_release(Input.is_action_just_released("jump") and velocity.y < 0)
		
		move_com.handle_speed_change(Input.is_action_pressed("run"))
		
		move_com.handle_move(direction)
	else:
		velocity = Vector2.ZERO
	
	if (not is_changing and is_alive and not is_entering):
		anim_com.handle_animation(direction, 
									not is_on_floor(), 
									"%s_jump" % state, 
									"%s_walk" % state, 
									"%s_idle" % state)
	
	if (is_on_floor() and not can_check_up):
		can_check_up = true
	
	if (can_enter and not is_entering):
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
	
	move_and_slide()

func change_state(new_state: String) -> void:
	if (state != new_state):
		is_changing = true
		Global.game_active = false
		anim_com.handle_anim_change(state,
										new_state,
										"normal_to_sandwich",
										"sandwich_to_candy",
										"normal_to_candy")
		state = new_state

func handle_death() -> void:
	is_alive = false
	Global.game_active = false
	anim_com.handle_death_anim("death", "death_move")

func reach_checkpoint(checkpoint_num: int) -> void:
	reached_checkpoint.emit(checkpoint_num)

func collect_donut() -> void:
	collected_donut.emit()

func enter_false_wall() -> void:
	z_index = -2
	match enter_dir:
		"right":
			anim_com.handle_enter_anim("enter_right")
		"left":
			anim_com.handle_enter_anim("enter_left")
		"up":
			anim_com.handle_enter_anim("enter_up")
		"down":
			anim_com.handle_enter_anim("enter_down")
	Global.game_active = false
	is_entering = true

func _on_up_check_body_entered(body: Node2D) -> void:
	if (can_check_up):
		if (body.has_method("player_hit")):
			body.player_hit(self)
			can_check_up = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "normal_to_sandwich" or
		anim_name == "sandwich_to_candy" or 
		anim_name == "normal_to_candy"):
			is_changing = false
			Global.game_active = true

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "death_move"):
		player_loses.emit()
	elif (anim_name == "enter_left" or anim_name == "enter_right" or anim_name == "enter_up" or anim_name == "enter_down"):
		if (returning):
			player_returned.emit(false_wall_exit)
		else:
			player_entered.emit(false_wall_exit, special_cam_point)
		anim_com.reset_move_player("idle")
