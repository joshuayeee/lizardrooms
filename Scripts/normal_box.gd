extends StaticBody2D

class_name NormalBox

const BOX_PIECE = preload("uid://cga2t0yjrghiv")

enum Contains {NOTHING, DONUT, ITEM, CUPCAKE}
@export var contains: Contains

@onready var move_player: AnimationPlayer = $MovePlayer

var item_manager: ItemManager = null
var is_empty: bool = false

func player_hit(player: Player) -> void:
	var state: String = player.state
	if (state == "sandwich" or state == "candy"):
		var piece_1: BoxPiece = BOX_PIECE.instantiate()
		piece_1.global_position = global_position
		
		var piece_2: BoxPiece = BOX_PIECE.instantiate()
		piece_2.global_position = global_position
		piece_2.direction = -1.0
		
		item_manager.spawn_item_front(piece_1)
		item_manager.spawn_item_front(piece_2)
		
		call_deferred("queue_free")
	
	move_player.play("move")

func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move"):
		move_player.play("idle")
