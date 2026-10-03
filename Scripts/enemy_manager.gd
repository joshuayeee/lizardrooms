extends Node2D

class_name EnemyManager

func _ready() -> void:
	for child in get_children():
		child.created_poof.connect(add_poof)
		
		if (child is Kaboom):
			child.created_explosion.connect(add_explosion)

func add_poof(poof: Poof) -> void:
	add_child(poof)

func add_explosion(explosion: Explosion) -> void:
	add_child(explosion)
