extends Area2D

class_name Donut

const PICKUP = preload("uid://1tlxry6mbhrm")

@onready var move_player: AnimationPlayer = $MovePlayer

var from_box: bool = false

func _ready() -> void:
	if (from_box):
		move_player.play("move")

func handle_collect() -> void:
	EventsBus.play_sound_request.emit(PICKUP)
	call_deferred("queue_free")

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move"):
		call_deferred("queue_free")

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.collect_donut()
		handle_collect()
	elif (body is Jawbreaker):
		body.handle_hit_donut()
		handle_collect()
