extends Node2D

class_name CheckpointManager

func _ready() -> void:
	var i: int = 0
	for child in get_children():
		child.my_num = i
		i += 1
