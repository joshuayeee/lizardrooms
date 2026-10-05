extends Enemy

class_name Stubby

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var anim_com: AnimCom = $Components/AnimCom

var direction: float = -1.0

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		if (is_active):
			move_com.handle_hori_move(direction)
			anim_com.handle_animation(direction,
								not is_on_floor(),
								"idle",
								"walk",
								"idle")
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (is_active and Global.game_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true
