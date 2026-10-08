extends CharacterBody2D

class_name Boss

signal lost_fight()

@export var lives: int = 12

var is_active: bool = false

var player: Player = null

func start_fight() -> void:
	pass

func handle_hit(attack_type: String) -> bool:
	return false
