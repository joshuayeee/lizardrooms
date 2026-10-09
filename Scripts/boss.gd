extends CharacterBody2D

class_name Boss

signal lost_fight()
signal created_enemy(enemy: Enemy)

@export var lives: int = 6

var is_active: bool = false

var player: Player = null

var is_vulnerable: bool = false
var can_attack: bool = false

func start_fight() -> void:
	pass

func handle_hit(attack_type: String) -> bool:
	return false
