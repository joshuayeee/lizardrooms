extends Enemy

class_name Stubby

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var move_com: MoveCom = $Components/MoveCom
@onready var anim_com: AnimCom = $Components/AnimCom

var direction: float = 1.0
var can_hurt_player: bool = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		move_com.handle_move(direction)
	else:
		velocity = Vector2.ZERO
	
	anim_com.handle_animation(direction,
								not is_on_floor(),
								"idle",
								"walk",
								"idle")
	
	move_and_slide()

func hurt() -> void:
	queue_free()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (can_hurt_player and Global.game_active):
			body.hurt()
