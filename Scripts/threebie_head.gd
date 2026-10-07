extends Enemy

class_name ThreebieHead

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var left_point_1: Node2D = $LeftPoint1
@onready var left_point_2: Node2D = $LeftPoint2
@onready var left_point_3: Node2D = $LeftPoint3
@onready var right_point_1: Node2D = $RightPoint1
@onready var right_point_2: Node2D = $RightPoint2
@onready var right_point_3: Node2D = $RightPoint3
@onready var move_com: MoveCom = $Components/MoveCom

@onready var final_point: Vector2 = global_position

@onready var lp_1_pos: Vector2 = left_point_1.global_position
@onready var lp_2_pos: Vector2 = left_point_2.global_position
@onready var lp_3_pos: Vector2 = left_point_3.global_position
@onready var rp_1_pos: Vector2 = right_point_1.global_position
@onready var rp_2_pos: Vector2 = right_point_2.global_position
@onready var rp_3_pos: Vector2 = right_point_3.global_position

@onready var lp_1_dir: Vector2 = (lp_1_pos - final_point).normalized()
@onready var lp_2_dir: Vector2 = (lp_2_pos - lp_1_pos).normalized()
@onready var lp_3_dir: Vector2 = (lp_3_pos - lp_2_pos).normalized()
@onready var rp_1_dir: Vector2 = (rp_1_pos - final_point).normalized()
@onready var rp_2_dir: Vector2 = (rp_2_pos - rp_1_pos).normalized()
@onready var rp_3_dir: Vector2 = (rp_3_pos - rp_2_pos).normalized()

@onready var final_dir_right: Vector2 = (final_point - rp_3_pos).normalized()
@onready var final_dir_left: Vector2 = (final_point - lp_3_pos).normalized()

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

enum Points {ONE, TWO, THREE, FINAL}
var point: Points = Points.ONE

func _ready() -> void:
	is_active = true
	
	sprite_2d.flip_h = (direction == Directions.RIGHT)

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			match direction:
				Directions.LEFT:
					match point:
						Points.ONE:
							move_com.handle_move_towards(lp_1_dir)
							
							if (within_range(global_position, lp_1_pos)):
								point = Points.TWO
						Points.TWO:
							move_com.handle_move_towards(lp_2_dir)
							
							if (within_range(global_position, lp_2_pos)):
								point = Points.THREE
						Points.THREE:
							move_com.handle_move_towards(lp_3_dir)
							
							if (within_range(global_position, lp_3_pos)):
								point = Points.FINAL
						Points.FINAL:
							move_com.handle_move_towards(final_dir_left)
				Directions.RIGHT:
					match point:
						Points.ONE:
							move_com.handle_move_towards(rp_1_dir)
							
							if (within_range(global_position, rp_1_pos)):
								point = Points.TWO
						Points.TWO:
							move_com.handle_move_towards(rp_2_dir)
							
							if (within_range(global_position, rp_2_pos)):
								point = Points.THREE
						Points.THREE:
							move_com.handle_move_towards(rp_3_dir)
							
							if (within_range(global_position, rp_3_pos)):
								point = Points.FINAL
						Points.FINAL:
							move_com.handle_move_towards(final_dir_right)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func within_range(point_1: Vector2, point_2: Vector2) -> bool:
	return abs(point_1.distance_to(point_2)) < 1.0

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()
