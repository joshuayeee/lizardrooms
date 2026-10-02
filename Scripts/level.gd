extends Screen

class_name Level

const PLAYER = preload("uid://b7nu3em0ku77g")
const CAM = preload("uid://caj7fxc0ctv5a")

@export var front_layer: CanvasLayer = null
@export var mid_layer: CanvasLayer = null
@export var UI_layer: CanvasLayer = null
@export var back_layer: CanvasLayer = null
@export var checkpoint_manager: CheckpointManager = null
@export var cam_point_manager: CamPointManager = null
@export var jawbreaker_manager: JawbreakerManager = null
@export var lives_label: Label = null
@export var donuts_label: Label = null

var checkpoint_num: int = 0
var world_level_text: String = ""
var world_title_text: String = ""
var level_name: String = ""
var player: Player = null
var cam: Cam = null

func _ready() -> void:
	Global.game_active = true
	
	var checkpoint: Checkpoint = checkpoint_manager.get_child(checkpoint_num)
	var spawn_point: Marker2D = checkpoint.spawn_point
	
	player = spawn_player(spawn_point)
	player.player_entered.connect(handle_player_enter)
	player.player_returned.connect(handle_player_return)
	player.request_layer_change.connect(change_player_layer)

	cam = spawn_cam(spawn_point, player)
	cam_point_manager.connect_points_to_cam(cam)
	
	connect_player_request.emit(player)
	
	update_labels_request.emit()

func spawn_player(spawn_point: Marker2D) -> Player:
	var new_player: Player = PLAYER.instantiate()
	new_player.global_position = spawn_point.global_position
	new_player.state = player_state
	new_player.jawbreaker_manager = jawbreaker_manager
	front_layer.add_child(new_player)
	return new_player

func spawn_cam(spawn_point: Marker2D, target: Node2D) -> Cam:
	var new_cam: Cam = CAM.instantiate()
	new_cam.global_position.x = spawn_point.global_position.x
	new_cam.global_position.y = 0.0
	new_cam.target = target
	front_layer.add_child(new_cam)
	return new_cam

func respawn() -> void:
	load_transition_request.emit(world_level_text, world_title_text, level_name)

func game_over() -> void:
	load_screen_request.emit("game_over_screen")

func update_donuts_label(donuts: int) -> void:
	donuts_label.text = str(donuts)

func update_lives_label(lives: int) -> void:
	lives_label.text = str(lives)

func handle_player_enter(false_wall_exit: FalseWallExit, 
							special_cam_point: SpecialCamPoint) -> void:
	player.global_position = false_wall_exit.global_position
	cam.global_position = special_cam_point.global_position
	cam.target = special_cam_point
	change_player_layer("front")
	Global.game_active = true

func handle_player_return(false_wall_exit: FalseWallExit) -> void:
	player.global_position = false_wall_exit.global_position
	cam.reset_y_pos()
	cam.target = player
	change_player_layer("front")
	player.returning = false
	Global.game_active = true

func change_player_layer(layer_name: String) -> void:
	match layer_name:
		"front":
			player.reparent(front_layer)
		"mid":
			player.reparent(mid_layer)
		"back":
			player.reparent(back_layer)
