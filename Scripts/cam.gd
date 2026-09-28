extends Camera2D

class_name Cam

@export var target: Node2D = null

func _process(_delta: float) -> void:
	if (target != null):
		position.x = target.position.x
