extends Screen

class_name TitleScreen

func _on_start_button_pressed() -> void:
	load_transition_request.emit("1-1", "THE LOBBY", "world_1_level_1")


#debug
func _input(_event: InputEvent) -> void:
	if (Input.is_action_pressed("debug")):
		load_transition_request.emit("DEBUG", "", "debug_level")
