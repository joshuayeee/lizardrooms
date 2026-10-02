extends Node2D

class_name BonusBoxManager

@export var item_manager: ItemManager = null

func _ready() -> void:
	for child in get_children():
		child.item_manager = item_manager
		child.bonus_finished.connect(disable_boxes)

func disable_boxes() -> void:
	for child in get_children():
		child.set_to_empty()
