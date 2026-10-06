extends CharacterBody2D

class_name Sandwich

@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var blink_player: AnimationPlayer = $BlinkPlayer
@onready var end_timer: Timer = $EndTimer

func _physics_process(delta: float) -> void:
	gravity_com.handle_gravity(delta)
	move_and_slide()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.change_state("sandwich")
		call_deferred("queue_free")

func _on_start_blink_timer_timeout() -> void:
	blink_player.play("blink")
	end_timer.start()

func _on_end_timer_timeout() -> void:
	call_deferred("queue_free")
