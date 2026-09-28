extends Node2D

class_name ItemManager

@onready var foreground: Node2D = $Foreground
@onready var background: Node2D = $Background

func spawn_item_back(item: Node2D) -> void:
	background.call_deferred("add_child", item)

func spawn_item_front(item: Node2D) -> void:
	foreground.call_deferred("add_child", item)
