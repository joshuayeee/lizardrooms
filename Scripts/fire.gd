extends Area2D

class_name Fire

const FIRE_DROP = preload("uid://drxj8iald2kkp")

signal created_drop(drop: FireDrop)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var drop_timer: Timer = $DropTimer
@onready var right_min_point: Node2D = $RightMinPoint
@onready var right_max_point: Node2D = $RightMaxPoint
@onready var left_min_point: Node2D = $LeftMinPoint
@onready var left_max_point: Node2D = $LeftMaxPoint

enum Directions {LEFT, RIGHT}
var direction: Directions = Directions.LEFT

var use_drop_attack: bool = false

func _ready() -> void:
	sprite_2d.flip_h = (direction == Directions.RIGHT)
	
	if (use_drop_attack):
		drop_timer.start()

func create_fire_drop() -> void:
	var drop: FireDrop = FIRE_DROP.instantiate()
	drop.global_position.y = global_position.y
	match direction:
		Directions.LEFT:
			drop.global_position.x = randf_range(left_min_point.global_position.x, left_max_point.global_position.x)
		Directions.RIGHT:
			drop.global_position.x = randf_range(right_min_point.global_position.x, right_max_point.global_position.x)
	
	created_drop.emit(drop)

func _on_drop_timer_timeout() -> void:
	if (Global.game_active):
		create_fire_drop()

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
