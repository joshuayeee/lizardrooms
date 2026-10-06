extends CharacterBody2D

class_name Mouthbreaker

@onready var move_com: MoveCom = $Components/MoveCom

var x_dir: float = -1.0
var y_dir: float = 1.0

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		move_com.handle_hori_move(x_dir)
		move_com.handle_vert_move(y_dir)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active):
			body.hurt()
