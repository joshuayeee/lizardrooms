extends CharacterBody2D

class_name FallBox

@onready var move_com: MoveCom = $Components/MoveCom
@onready var drop_timer: Timer = $DropTimer
@onready var life_timer: Timer = $LifeTimer

var can_drop: bool = false

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (can_drop):
			move_com.handle_vert_move(1.0)
	
	move_and_slide()

func start_drop_timer() -> void:
	if (not can_drop and drop_timer.is_stopped()):
		drop_timer.start()

func _on_drop_timer_timeout() -> void:
	can_drop = true
	life_timer.start()

func _on_life_timer_timeout() -> void:
	call_deferred("queue_free")
