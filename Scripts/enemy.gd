extends CharacterBody2D

class_name Enemy

const POOF = preload("uid://c1gscfcr3ieqr")

signal created_poof(poof: Poof)

@export var poof_point: Node2D = null

func hurt() -> void:
	var poof: Poof = POOF.instantiate()
	poof.global_position = poof_point.global_position
	created_poof.emit(poof)
	queue_free()

func hit_by_jawbreaker() -> void:
	var poof: Poof = POOF.instantiate()
	poof.global_position = poof_point.global_position
	created_poof.emit(poof)
	queue_free()
