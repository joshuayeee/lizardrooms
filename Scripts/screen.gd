extends Node2D

class_name Screen

signal load_screen_request(screen_name: String)
signal load_level_request(world_level_text: String, world_title_text: String, level_name: String)
signal load_transition_request(world_level_text: String, world_title_text: String, level_name: String)
signal reset_request()
signal connect_player_request(player: Player)
signal update_labels_request()
