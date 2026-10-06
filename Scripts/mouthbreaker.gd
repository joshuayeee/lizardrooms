extends CharacterBody2D

class_name Mouthbreaker

@onready var move_com: MoveCom = $Components/MoveCom

var direction: Vector2 = Vector2.ZERO 

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		move_com.handle_move_towards(direction)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
