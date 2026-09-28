extends Screen

class_name GameOverScreen

func _on_timer_timeout() -> void:
	main.reset_stats()
	main.load_screen("title_screen")
