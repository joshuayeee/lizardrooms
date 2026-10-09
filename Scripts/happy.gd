extends Enemy

class_name Happy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var left_ground_check: Area2D = $LeftGroundCheck
@onready var right_ground_check: Area2D = $RightGroundCheck
@onready var move_com: MoveCom = $Components/MoveCom
@onready var gravity_com: GravityCom = $Components/GravityCom

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		if (is_active):
			match direction:
				Directions.LEFT:
					move_com.handle_hori_move(-1.0)
				Directions.RIGHT:
					move_com.handle_hori_move(1.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.LEFT):
		direction = Directions.RIGHT
		sprite_2d.flip_h = true

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction == Directions.RIGHT):
		direction = Directions.LEFT
		sprite_2d.flip_h = false

func _on_left_ground_check_body_exited(_body: Node2D) -> void:
	if (not left_ground_check.has_overlapping_bodies()):
		if (direction == Directions.LEFT):
			direction = Directions.RIGHT
			sprite_2d.flip_h = true

func _on_right_ground_check_body_exited(_body: Node2D) -> void:
	if (not right_ground_check.has_overlapping_bodies()):
		if (direction == Directions.RIGHT):
			direction = Directions.LEFT
			sprite_2d.flip_h = false

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				body.hurt()
			else:
				poof_death()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true
