extends Node2D

class_name EnemyManager

func _ready() -> void:
	for child in get_children():
		if (child is Enemy):
			connect_poof(child)
			
			if (child is Kaboom):
				connect_explosion(child)

func connect_poof(my_enemy: Enemy) -> void:
	my_enemy.created_poof.connect(add_poof)

func connect_explosion(my_kaboom: Kaboom) -> void:
	my_kaboom.created_explosion.connect(add_explosion)

func add_poof(poof: Poof) -> void:
	add_child(poof)

func add_explosion(explosion: Explosion) -> void:
	add_child(explosion)
