extends CharacterBody2D

class_name TwisterHead

@onready var move_com: MoveCom = $Components/MoveCom

var y_dir: float = 1.0

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		move_com.handle_vert_move(y_dir)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()

func _on_life_timer_timeout() -> void:
	call_deferred("queue_free")
