extends Camera2D

class_name Cam

@export var target: Node2D = null

@onready var init_y_pos: float = position.y

func _process(_delta: float) -> void:
	if (target != null):
		position.x = target.position.x

func reset_y_pos() -> void:
	position.y = init_y_pos
