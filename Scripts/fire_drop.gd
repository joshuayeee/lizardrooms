extends CharacterBody2D

class_name FireDrop

@onready var move_com: MoveCom = $Components/MoveCom

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		move_com.handle_vert_move(1.0)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")


func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
