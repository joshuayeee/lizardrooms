extends CharacterBody2D

class_name Candy

@onready var gravity_com: GravityCom = $Components/GravityCom

func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.change_state("candy")
		call_deferred("queue_free")
