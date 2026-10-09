extends Enemy

class_name ArchMinion

@export var center: Node2D = null
@export var radius: float = 32.0

@onready var move_com: MoveCom = $Components/MoveCom

var angle: float = 0.0

func _ready() -> void:
	is_active = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			if (center != null):
				move_com.handle_orbit_move(center, radius, delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()
