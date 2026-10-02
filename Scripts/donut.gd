extends Area2D

class_name Donut

@onready var move_player: AnimationPlayer = $MovePlayer

var from_box: bool = false

func _ready() -> void:
	if (from_box):
		move_player.play("move")

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move"):
		call_deferred("queue_free")

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.collect_donut()
		call_deferred("queue_free")
