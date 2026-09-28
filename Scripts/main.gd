extends Node

class_name Main

var screen: Screen = null

var lives: int = 2
var donuts: int = 0
var checkpoint_num: int = 0

func _ready() -> void:
	load_screen("title_screen")

func unload_screen() -> void:
	if (screen != null):
		screen.queue_free()
		screen = null

func load_screen(screen_name: String) -> void:
	unload_screen()
	var screen_path: String = "res://Scenes/Screens/%s.tscn" % screen_name
	screen = load(screen_path).instantiate()
	screen.main = self
	add_child(screen)

func load_level(world_level_text: String, 
					world_title_text: String, 
					level_name: String) -> void:
	unload_screen()
	var level_path: String = "res://Scenes/Levels/%s.tscn" % level_name
	screen = load(level_path).instantiate()
	screen.main = self
	screen.checkpoint_num = checkpoint_num
	screen.world_level_text = world_level_text
	screen.world_title_text = world_title_text
	screen.level_name = level_name
	add_child(screen)

func load_transition(world_level_text: String, 
						world_title_text: String,
						level_name: String) -> void:
	unload_screen()
	var screen_path: String = "res://Scenes/Screens/transition_screen.tscn"
	screen = load(screen_path).instantiate()
	screen.main = self
	screen.world_level_text = world_level_text
	screen.world_title_text = world_title_text
	screen.level_name = level_name
	add_child(screen)

func reset_stats() -> void:
	lives = 2
	donuts = 0
	checkpoint_num = 0

func _input(_event: InputEvent) -> void:
	if (Input.is_action_pressed("quit")):
		get_tree().quit()
