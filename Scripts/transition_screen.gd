extends Screen

class_name TransitionScreen

@onready var world_level_label: Label = $CanvasLayer/WorldLevelLabel
@onready var world_title_label: Label = $CanvasLayer/WorldTitleLabel

var world_level_text: String = ""
var world_title_text: String = ""
var level_name: String = ""

func _ready() -> void:
	world_level_label.text = world_level_text
	world_title_label.text = world_title_text

func _on_timer_timeout() -> void:
	main.load_level(world_level_text, world_title_text, level_name)
