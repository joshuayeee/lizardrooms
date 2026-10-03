extends Node2D

class_name EnemyManager

func _ready() -> void:
	for child in get_children():
		child.created_poof.connect(add_poof)

func add_poof(poof: Poof) -> void:
	add_child(poof)
