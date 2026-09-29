extends Area2D

class_name FalseWallEnter

@export var enter_dir: String = ""
@export var my_exit: FalseWallExit = null
@export var special_cam_point: SpecialCamPoint = null
@export var is_returning: bool = false

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.can_enter = true
		body.enter_dir = enter_dir
		body.false_wall_exit = my_exit
		if (is_returning):
			body.returning = true
		else:
			body.special_cam_point = special_cam_point

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		body.can_enter = false
		if (is_returning):
			body.returning = false
