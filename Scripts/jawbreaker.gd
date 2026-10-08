extends CharacterBody2D

class_name Jawbreaker

signal destroyed()

@onready var move_com: MoveCom = $Components/MoveCom

var x_dir: float = 1.0
var y_dir: float = 1.0

func _physics_process(_delta: float) -> void:
	move_com.handle_hori_move(x_dir)
	move_com.handle_vert_move(y_dir)
	move_and_slide()

func handle_destroy() -> void:
	destroyed.emit()
	queue_free()

func _on_check_up_body_entered(_body: Node2D) -> void:
	if (y_dir < 0):
		y_dir = 1.0

func _on_check_down_body_entered(_body: Node2D) -> void:
	if (y_dir > 0):
		y_dir = -1.0

func _on_check_left_body_entered(_body: Node2D) -> void:
	if (x_dir < 0):
		x_dir = 1.0

func _on_check_right_body_entered(_body: Node2D) -> void:
	if (x_dir > 0):
		x_dir = -1.0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	handle_destroy()

func _on_life_timer_timeout() -> void:
	handle_destroy()

func _on_enemy_check_body_entered(body: Node2D) -> void:
	if (body is Enemy):
		if (body.is_active):
			body.hit_by_jawbreaker()
			handle_destroy()

func _on_boss_check_body_entered(body: Node2D) -> void:
	if (body is Boss):
		if (body.is_active):
			if (body.handle_hit("jawbreaker")):
				handle_destroy()
