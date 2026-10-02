extends Screen

class_name BonusTransitionScreen

var world_level_text: String = ""
var world_title_text: String = ""
var level_name: String = ""

func _on_timer_timeout() -> void:
	load_bonus_request.emit(world_level_text, world_title_text, level_name)
