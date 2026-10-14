extends Node2D

class_name EndCutsceneManager

signal finished_cutscene()

@export var cutscene_text_manager: CutsceneTextManager = null
@export var fake_maple_cutscene: FakeMapleCutscene = null

@onready var transition_timer: Timer = $TransitionTimer
@onready var mark_idle_timer: Timer = $MarkIdleTimer
@onready var mark_laugh_timer: Timer = $MarkLaughTimer
@onready var mark_run_timer: Timer = $MarkRunTimer

func start_cutscene() -> void:
	handle_maple_talk()

func handle_maple_talk() -> void:
	cutscene_text_manager.write_text("WAFFLE! THANK YOU FOR SAVING ME!")
	cutscene_text_manager.finished_writing.connect(handle_transition)

func handle_transition() -> void:
	fake_maple_cutscene.play_anim("transition")
	transition_timer.start()

func handle_mark_idle() -> void:
	fake_maple_cutscene.play_anim("mark_idle")
	mark_idle_timer.start()

func handle_mark_laugh() -> void:
	fake_maple_cutscene.play_anim("mark_laugh")
	mark_laugh_timer.start()

func handle_mark_run() -> void:
	fake_maple_cutscene.set_facing_right(true)
	fake_maple_cutscene.play_anim("mark_move")
	fake_maple_cutscene.play_move_anim("move")
	mark_run_timer.start()

func finish_cutscene() -> void:
	finished_cutscene.emit()

func _on_transition_timer_timeout() -> void:
	handle_mark_idle()

func _on_mark_idle_timer_timeout() -> void:
	handle_mark_laugh()

func _on_mark_laugh_timer_timeout() -> void:
	handle_mark_run()

func _on_mark_run_timer_timeout() -> void:
	finish_cutscene()
