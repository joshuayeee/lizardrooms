extends Enemy

class_name Stubby

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var anim_com: AnimCom = $Components/AnimCom
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction: float = -1.0
var is_active: bool = false

func _physics_process(delta: float) -> void:
	if (Global.game_active and is_active):
		gravity_com.handle_gravity(delta)
		move_com.handle_move(direction)
		anim_com.handle_animation(direction,
							not is_on_floor(),
							"idle",
							"walk",
							"idle")
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt() -> void:
	is_active = false
	animation_player.play("death")

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (is_active and Global.game_active):
			body.hurt()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "death"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true
