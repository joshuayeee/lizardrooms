extends Enemy

class_name ThreebieHead

signal reached_final_point(head: ThreebieHead)
signal head_destroyed()

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

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

enum Points {ONE, TWO, THREE, FINAL, NONE}
var point: Points = Points.ONE

var host_still_alive: bool = true

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
							move_com.handle_move_to(lp_1_pos)
							
							if (within_range(global_position, lp_1_pos)):
								point = Points.TWO
						Points.TWO:
							move_com.handle_move_to(lp_2_pos)
							
							if (within_range(global_position, lp_2_pos)):
								point = Points.THREE
						Points.THREE:
							move_com.handle_move_to(lp_3_pos)
							
							if (within_range(global_position, lp_3_pos)):
								point = Points.FINAL
						Points.FINAL:
							move_com.handle_move_to(final_point)
							
							if (within_range(global_position, final_point)):
								reached_final_point.emit(self)
								point = Points.NONE
						Points.NONE:
							move_com.handle_hori_move(1.0)
				Directions.RIGHT:
					match point:
						Points.ONE:
							move_com.handle_move_to(rp_1_pos)
							
							if (within_range(global_position, rp_1_pos)):
								point = Points.TWO
						Points.TWO:
							move_com.handle_move_to(rp_2_pos)
							
							if (within_range(global_position, rp_2_pos)):
								point = Points.THREE
						Points.THREE:
							move_com.handle_move_to(rp_3_pos)
							
							if (within_range(global_position, rp_3_pos)):
								point = Points.FINAL
						Points.FINAL:
							move_com.handle_move_to(final_point)
							
							if (within_range(global_position, final_point)):
								reached_final_point.emit(self)
								point = Points.NONE
						Points.NONE:
							move_com.handle_hori_move(1.0)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func poof_death() -> void:
	head_destroyed.emit()
	super()

func within_range(point_1: Vector2, point_2: Vector2) -> bool:
	return (point_1.distance_to(point_2) < 2.0)

func destroy() -> void:
	call_deferred("queue_free")

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	head_destroyed.emit()
	destroy()
