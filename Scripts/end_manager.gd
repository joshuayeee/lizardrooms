extends Node2D

class_name EndManager

signal request_next_level(next_wl: String, next_wt: String, next_name: String, player_state: String, is_bonus: bool)

@export var next_world_level: String = ""
@export var next_world_title: String = ""
@export var next_level_file: String = ""
@export var cam_point: CamPoint = null
@export var player_pos: Node2D = null
@export var end_cutscene_manager: EndCutsceneManager = null

var player: Player = null

func _ready() -> void:
	if (cam_point != null):
		cam_point.player_reached.connect(handle_player_reach)
	
	if (end_cutscene_manager != null):
		end_cutscene_manager.finished_cutscene.connect(handle_cutscene_finished)

func handle_player_reach() -> void:
	Global.game_active = false
	player.global_position = player_pos.global_position
	player.got_to_end()
	end_cutscene_manager.start_cutscene()

func handle_cutscene_finished() -> void:
	request_next_level.emit(next_world_level, next_world_title, next_level_file, player.state, false)
