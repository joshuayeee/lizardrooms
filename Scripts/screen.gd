extends Node2D

class_name Screen

signal load_screen_request(screen_name: String)
signal load_level_request(world_level_text: String, world_title_text: String, level_name: String)
signal load_transition_request(world_level_text: String, world_title_text: String, level_name: String)
signal load_bonus_request(world_level_text: String, world_title_text: String, level_name: String)
signal load_bonus_transition_request(world_level_text: String, world_title_text: String, level_name: String)
signal reset_request()
signal connect_player_request(player: Player)
signal update_labels_request()
signal connect_end_manager_request(end_manager: EndManager)

var player_state: String = "normal"

var sound_player: AudioStreamPlayer = null

func _ready() -> void:
	set_up_sound_player()

func set_up_sound_player() -> void:
	sound_player = AudioStreamPlayer.new()
	add_child(sound_player)
	EventsBus.play_sound_request.connect(play_sound)

func play_sound(stream: AudioStream) -> void:
	if (sound_player.stream != stream):
		sound_player.stream = stream
	sound_player.play()
