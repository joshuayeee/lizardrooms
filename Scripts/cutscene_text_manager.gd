extends Control

class_name CutsceneTextManager

signal finished_writing()

@export var my_label: Label = null

@onready var write_timer: Timer = $WriteTimer

func write_text(my_text: String) -> void:
	for my_char in my_text:
		write_timer.start()
		await write_timer.timeout
		my_label.text += my_char
	finished_writing.emit()
