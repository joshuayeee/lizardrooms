extends Screen

class_name TitleScreen

func _on_start_button_pressed() -> void:
	main.load_transition("1-1", "THE LOBBY", "world_1_level_1")
