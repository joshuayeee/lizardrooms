extends Node2D

class_name CannyManager

@export var enemy_manager: EnemyManager

func _ready() -> void:
	for child in get_children():
		if (child is Canny):
			child.enemy_manager = enemy_manager

func inject_player(player: Player):
	for child in get_children():
		if (child is Canny):
			child.player = player
