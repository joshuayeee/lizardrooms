extends Screen

class_name Level

const PLAYER = preload("uid://b7nu3em0ku77g")
const CAM = preload("uid://caj7fxc0ctv5a")

@export var checkpoint_manager: CheckpointManager = null
@export var lives_label: Label = null
@export var donuts_label: Label = null

var checkpoint_num: int = 0
var world_level_text: String = ""
var world_title_text: String = ""
var level_name: String = ""

func _ready() -> void:
	Global.game_active = true
	
	var checkpoint: Checkpoint = checkpoint_manager.get_child(checkpoint_num)
	var spawn_point: Marker2D = checkpoint.spawn_point
	
	var player: Player = spawn_player(spawn_point)
	spawn_cam(spawn_point, player)
	
	update_lives_label()
	update_donuts_label()

func spawn_player(spawn_point: Marker2D) -> Player:
	var player: Player = PLAYER.instantiate()
	player.global_position = spawn_point.global_position
	player.main = main
	player.level = self
	add_child(player)
	return player

func spawn_cam(spawn_point: Marker2D, target: Node2D) -> void:
	var cam: Cam = CAM.instantiate()
	cam.global_position.x = spawn_point.global_position.x
	cam.global_position.y = 0.0
	cam.target = target
	add_child(cam)

func respawn() -> void:
	main.load_transition(world_level_text, world_title_text, level_name)

func game_over() -> void:
	main.load_screen("game_over_screen")

func update_donuts_label() -> void:
	donuts_label.text = str(main.donuts)

func update_lives_label() -> void:
	lives_label.text = str(main.lives)
