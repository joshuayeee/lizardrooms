extends Enemy

class_name Bullet

@onready var move_com: MoveCom = $Components/MoveCom
@onready var sprite_2d: Sprite2D = $Sprite2D

var x_dir: float = -1.0

func _ready() -> void:
	is_active = true
	
	if (x_dir > 0):
		sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		move_com.handle_hori_move(x_dir)
	else:
		velocity = Vector2.ZERO
	
	if (move_and_collide(velocity * delta)):
		poof_death()

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and not body.has_cupcake):
			body.hurt()
		elif (body.has_cupcake):
			poof_death()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
