extends Node2D

class_name BoxManager

@export var item_manager: ItemManager = null

func _ready() -> void:
	for child in get_children():
		child.item_manager = item_manager
