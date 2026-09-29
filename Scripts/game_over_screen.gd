extends Screen

class_name GameOverScreen

func _on_timer_timeout() -> void:
	reset_request.emit()
	load_screen_request.emit("title_screen")
