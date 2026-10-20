extends Node2D

class_name GumballSpawner

const GUMBALL = preload("uid://ys1stw2evkc6")
const GUMBALL_BODY = preload("uid://bil4h5dh2ujyt")

@export var my_layer: CanvasLayer = null

@onready var spawn_timer: Timer = $SpawnTimer

func spawn_gumball() -> void:
	var gumball: Gumball = GUMBALL.instantiate()
	gumball.global_position = global_position
	
	var gumball_body: GumballBody = GUMBALL_BODY.instantiate()
	gumball_body.global_position = global_position
	gumball_body.set_gumball(gumball)
	
	my_layer.add_child(gumball_body)
	my_layer.add_child(gumball)


func _on_spawn_timer_timeout() -> void:
	spawn_gumball()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spawn_gumball()
	spawn_timer.start()
