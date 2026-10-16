extends Node2D

class_name BossManager

const LESSIE_BRIDGE = preload("uid://n3lpncrnt7vm")

@export var boss: Boss = null
@export var cam_point: CamPoint = null
@export var left_boss_wall: BossWall = null
@export var right_boss_wall: BossWall = null
@export var enemy_manager: EnemyManager = null
@export var box_manager: BoxManager = null

var started_fight: bool = false

func _ready() -> void:
	if (boss != null):
		boss.lost_fight.connect(handle_lost_fight)
		
		if (enemy_manager != null):
			enemy_manager.connect_boss(boss.created_enemy)
		
		if (boss is Fluores):
			boss.created_bolt.connect(add_bolt)
		elif (boss is Lessie):
			boss.connect_fire_sig.connect(handle_fire_connect)
			boss.request_build_bridge.connect(create_lessie_bridge)
		elif (boss is Arch):
			boss.created_bullet.connect(add_arch_bullet)
	
	if (cam_point != null):
		cam_point.player_reached.connect(handle_start_fight)

func inject_player(player: Player) -> void:
	boss.player = player

func handle_start_fight() -> void:
	if (not started_fight):
		left_boss_wall.set_col_disable(false)
		right_boss_wall.set_col_disable(false)
		boss.start_fight()
		started_fight = true

func handle_lost_fight() -> void:
	right_boss_wall.set_col_disable(true)
	cam_point.cam_leave_right = true
	cam_point.cam_enter_left = true
	cam_point.cam_enter_right = false

func add_bolt(bolt: Bolt) -> void:
	add_child(bolt)

func handle_fire_connect(fire_sig: Signal) -> void:
	fire_sig.connect(add_drop)

func add_drop(drop: FireDrop) -> void:
	add_child(drop)

func add_arch_bullet(bullet: ArchBullet) -> void:
	add_child(bullet)

func create_lessie_bridge(spawn_point: Node2D) -> void:
	if (box_manager != null):
		var lessie_bridge: Node2D = LESSIE_BRIDGE.instantiate()
		lessie_bridge.global_position = spawn_point.global_position
		box_manager.add_child(lessie_bridge)
