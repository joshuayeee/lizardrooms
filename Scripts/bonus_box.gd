extends StaticBody2D

class_name BonusBox

const CANDY = preload("uid://bqisoxfiesbp6")
const HEART = preload("uid://cllnwd3ojlofg")

signal bonus_finished()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_player: AnimationPlayer = $MovePlayer
@onready var spawn_point: Marker2D = $SpawnPoint

var item_manager: ItemManager = null
var is_empty: bool = false

func player_hit(_player: Player) -> void:
	if (not is_empty):
		randomize()
		var rand_num: int = randi_range(0, 3)
		match rand_num:
			0:
				var heart: Heart = HEART.instantiate()
				heart.global_position = spawn_point.global_position
				heart.can_move = false
				item_manager.spawn_item_back(heart)
			1:
				var heart: Heart = HEART.instantiate()
				heart.global_position = spawn_point.global_position
				heart.can_move = false
				heart.lives = 2
				item_manager.spawn_item_back(heart)
			2:
				var heart: Heart = HEART.instantiate()
				heart.global_position = spawn_point.global_position
				heart.can_move = false
				heart.lives = 3
				item_manager.spawn_item_back(heart)
			3:
				var candy: Candy = CANDY.instantiate()
				candy.global_position = spawn_point.global_position
				item_manager.spawn_item_back(candy)
		move_player.play("move")
		set_to_empty()
		bonus_finished.emit()

func set_to_empty() -> void:
	animation_player.play("empty")
	is_empty = true

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move"):
		move_player.play("idle")
