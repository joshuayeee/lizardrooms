extends CharacterBody2D

class_name Enemy

const POOF = preload("uid://c1gscfcr3ieqr")

signal created_poof(poof: Poof)

@export var poof_point: Node2D = null

func hurt() -> void:
	pass

func hit_by_jawbreaker() -> void:
	pass
