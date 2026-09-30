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
	connect_screen_signals()
	add_child(screen)

func load_level(world_level_text: String, 
					world_title_text: String, 
					level_name: String) -> void:
	unload_screen()
	var level_path: String = "res://Scenes/Levels/%s.tscn" % level_name
	screen = load(level_path).instantiate()
	connect_screen_signals()
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
	connect_screen_signals()
	screen.world_level_text = world_level_text
	screen.world_title_text = world_title_text
	screen.level_name = level_name
	add_child(screen)

func connect_screen_signals() -> void:
	screen.load_screen_request.connect(load_screen)
	screen.load_level_request.connect(load_level)
	screen.load_transition_request.connect(load_transition)
	screen.reset_request.connect(reset_stats)
	screen.connect_player_request.connect(connect_player_signals)
	screen.update_labels_request.connect(update_level_labels)

func reset_stats() -> void:
	lives = 2
	donuts = 0
	checkpoint_num = 0

func connect_player_signals(player: Player) -> void:
	player.collected_donut.connect(player_collected_donut)
	player.collected_heart.connect(player_collected_heart)
	player.player_loses.connect(handle_player_loss)
	player.reached_checkpoint.connect(player_reached_checkpoint)

func player_collected_donut() -> void:
	donuts += 1
	screen.update_donuts_label(donuts)

func player_collected_heart() -> void:
	lives += 1
	screen.update_lives_label(lives)

func handle_player_loss() -> void:
	lives -= 1
	
	if (lives < 0):
		screen.game_over()
		reset_stats()
	else:
		screen.respawn()
		donuts = 0

func player_reached_checkpoint(my_num: int) -> void:
	if (my_num > checkpoint_num):
		checkpoint_num = my_num

func update_level_labels() -> void:
	screen.update_donuts_label(donuts)
	screen.update_lives_label(lives)

func _input(_event: InputEvent) -> void:
	if (Input.is_action_pressed("quit")):
		get_tree().quit()
