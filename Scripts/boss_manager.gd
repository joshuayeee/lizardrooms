extends Node2D

class_name BossManager

@export var boss: Boss = null
@export var cam_point: CamPoint = null
@export var left_boss_wall: BossWall = null
@export var right_boss_wall: BossWall = null
@export var enemy_manager: EnemyManager = null

func _ready() -> void:
	if (boss != null):
		boss.lost_fight.connect(handle_lost_fight)
		
		if (enemy_manager != null):
			enemy_manager.connect_boss(boss.created_enemy)
		
		if (boss is Fluores):
			boss.created_bolt.connect(add_bolt)
	
	if (cam_point != null):
		cam_point.player_reached.connect(handle_start_fight)

func inject_player(player: Player) -> void:
	boss.player = player

func handle_start_fight() -> void:
	left_boss_wall.set_col_disable(false)
	right_boss_wall.set_col_disable(false)
	boss.start_fight()

func handle_lost_fight() -> void:
	print("YOU WIN!!!")

func add_bolt(bolt: Bolt) -> void:
	add_child(bolt)
