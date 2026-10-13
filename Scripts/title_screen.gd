extends Screen

class_name TitleScreen

@onready var new_game_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/NewGameLabel
@onready var continue_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/ContinueLabel
@onready var level_select_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/LevelSelectLabel
@onready var settings_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/SettingsLabel
@onready var exit_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer/ExitLabel

enum Options {NEW_GAME, CONTINUE, LEVEL_SELECT, SETTINGS, EXIT}
var curr_option: Options = Options.NEW_GAME

func _input(_event: InputEvent) -> void:
	if (Input.is_action_pressed("jump")):
		match curr_option:
			Options.NEW_GAME:
				handle_new_game()
			Options.CONTINUE:
				handle_continue()
			Options.LEVEL_SELECT:
				handle_level_select()
			Options.SETTINGS:
				handle_settings()
			Options.EXIT:
				handle_exit()
	elif (Input.is_action_just_pressed("up")):
		match curr_option:
			Options.NEW_GAME:
				set_selected(exit_label, Options.EXIT)
				set_unselected(new_game_label)
			Options.CONTINUE:
				set_selected(new_game_label, Options.NEW_GAME)
				set_unselected(continue_label)
			Options.LEVEL_SELECT:
				set_selected(continue_label, Options.CONTINUE)
				set_unselected(level_select_label)
			Options.SETTINGS:
				set_selected(level_select_label, Options.LEVEL_SELECT)
				set_unselected(settings_label)
			Options.EXIT:
				set_selected(settings_label, Options.SETTINGS)
				set_unselected(exit_label)
	elif (Input.is_action_just_pressed("down")):
		match curr_option:
			Options.NEW_GAME:
				set_selected(continue_label, Options.CONTINUE)
				set_unselected(new_game_label)
			Options.CONTINUE:
				set_selected(level_select_label, Options.LEVEL_SELECT)
				set_unselected(continue_label)
			Options.LEVEL_SELECT:
				set_selected(settings_label, Options.SETTINGS)
				set_unselected(level_select_label)
			Options.SETTINGS:
				set_selected(exit_label, Options.EXIT)
				set_unselected(settings_label)
			Options.EXIT:
				set_selected(new_game_label, Options.NEW_GAME)
				set_unselected(exit_label)
	
	if (Input.is_action_pressed("debug_num_1")):
		load_transition_request.emit("ENEMIES", "", "debug_level")
	elif (Input.is_action_pressed("debug_num_2")):
		load_transition_request.emit("FLUORES", "", "fluores_debug_level")
	elif (Input.is_action_pressed("debug_num_3")):
		load_transition_request.emit("LESSIE", "", "lessie_debug_level")
	elif (Input.is_action_pressed("debug_num_4")):
		load_transition_request.emit("ARCH", "", "arch_debug_level")

func set_selected(my_label: Label, my_option: Options) -> void:
	my_label.set("theme_override_colors/font_color", Color.WHITE)
	var new_text: String = ">%s" % my_label.text
	my_label.text = new_text
	curr_option = my_option

func set_unselected(my_label: Label) -> void:
	my_label.set("theme_override_colors/font_color", Color(0.333, 0.333, 0.333, 1.0))
	my_label.text = my_label.text.substr(1)

func handle_new_game() -> void:
	load_transition_request.emit("1-1", "THE LOBBY", "world_1_level_1")

func handle_continue() -> void:
	pass

func handle_level_select() -> void:
	pass

func handle_settings() -> void:
	pass

func handle_exit() -> void:
	pass
