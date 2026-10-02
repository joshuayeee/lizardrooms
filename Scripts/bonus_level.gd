extends Level

class_name BonusLevel

@export var bonus_door: Door = null

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
	
	bonus_door.next_world_level = world_level_text
	bonus_door.next_world_title = world_title_text
	bonus_door.next_level_name = level_name
