extends StaticBody2D

class_name SpecialBox

const DONUT = preload("uid://grdglvdkkcx")
const SANDWICH = preload("uid://bvdjxn5x33uwa")
const CANDY = preload("uid://bqisoxfiesbp6")
const HEART = preload("uid://cllnwd3ojlofg")
const CUPCAKE = preload("uid://kp1omc8ktlfw")

enum Contains {DONUT, ITEM, HEART, CUPCAKE, MULTI_DONUT}
@export var contains: Contains

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_player: AnimationPlayer = $MovePlayer
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var multi_timer: Timer = $MultiTimer

var item_manager: ItemManager = null
var is_empty: bool = false
var last_donut: bool = false

func player_hit(player: Player) -> void:
	var state: String = player.state
	if (not is_empty):
		if (contains != Contains.MULTI_DONUT):
			match contains:
				Contains.DONUT:
					player.collect_donut()
					var donut: Donut = DONUT.instantiate()
					donut.global_position = spawn_point.global_position
					donut.from_box = true
					item_manager.spawn_item_front(donut)
				Contains.ITEM:
					if (state == "normal"):
						var sandwich: Sandwich = SANDWICH.instantiate()
						sandwich.global_position = spawn_point.global_position
						item_manager.spawn_item_back(sandwich)
					else:
						var candy: Candy = CANDY.instantiate()
						candy.global_position = spawn_point.global_position
						item_manager.spawn_item_back(candy)
				Contains.HEART:
					var heart: Heart = HEART.instantiate()
					heart.global_position = spawn_point.global_position
					item_manager.spawn_item_back(heart)
				Contains.CUPCAKE:
					var cupcake: Cupcake = CUPCAKE.instantiate()
					cupcake.global_position = spawn_point.global_position
					item_manager.spawn_item_back(cupcake)
			move_player.play("move")
			animation_player.play("empty")
			is_empty = true
		else:
			player.collect_donut()
			var donut: Donut = DONUT.instantiate()
			donut.global_position = spawn_point.global_position
			donut.from_box = true
			item_manager.spawn_item_front(donut)
			move_player.play("move")
			animation_player.play("multi")
			
			if (last_donut):
				animation_player.play("empty")
				is_empty = true
			else:
				if (multi_timer.is_stopped()):
					multi_timer.start()


func _on_move_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move"):
		move_player.play("idle")

func _on_multi_timer_timeout() -> void:
	last_donut = true
