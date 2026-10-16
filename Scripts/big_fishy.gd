extends Enemy

class_name BigFishy

@onready var move_com: MoveCom = $Components/MoveCom
@onready var death_timer: Timer = $DeathTimer

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			move_com.handle_move_towards(Vector2.LEFT)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt() -> bool:
	return false

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active):
			if (not body.has_cupcake):
				if (not body.hit_invin):
					body.hurt()
			else:
				poof_death()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true
	
	death_timer.stop()

func _on_death_timer_timeout() -> void:
	poof_death()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if (is_active):
		death_timer.start()
