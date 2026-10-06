extends CharacterBody2D

class_name Canny

const BULLET = preload("uid://b4qltgag5er64")

@onready var move_com: MoveCom = $Components/MoveCom
@onready var stop_point: Node2D = $StopPoint
@onready var go_up_timer: Timer = $GoUpTimer
@onready var go_down_timer: Timer = $GoDownTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bullet_spawn_point: Node2D = $BulletSpawnPoint

@onready var stop_point_y: float = stop_point.position.y
@onready var init_point_y: float = position.y

var enemy_manager: EnemyManager = null
var player: Player = null

enum States {MOVE_UP, STOP, MOVE_DOWN}
var state: States = States.MOVE_UP

enum Directions {RIGHT, LEFT}
var direction: Directions = Directions.LEFT

var is_active: bool = false

func _physics_process(_delta: float) -> void:
	if (Global.game_active):
		if (is_active):
			
			if (player != null):
				if (player.position.x > position.x):
					direction = Directions.RIGHT
					sprite_2d.flip_h = true
				else:
					direction = Directions.LEFT
					sprite_2d.flip_h = false
			
			match state:
				States.MOVE_UP:
					move_com.handle_vert_move(-1.0)
					
					if (position.y <= stop_point_y):
						fire_bullet()
						go_down_timer.start()
						state = States.STOP
				States.STOP:
					velocity = Vector2.ZERO
				States.MOVE_DOWN:
					move_com.handle_vert_move(1.0)
					
					if (position.y >= init_point_y):
						go_up_timer.start()
						state = States.STOP
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func fire_bullet() -> void:
	var bullet: Bullet = BULLET.instantiate()
	
	bullet.global_position = bullet_spawn_point.global_position
	
	if (direction == Directions.RIGHT):
		bullet.x_dir = 1.0
	
	enemy_manager.connect_poof(bullet)
	enemy_manager.add_child(bullet)
	

func _on_go_up_timer_timeout() -> void:
	state = States.MOVE_UP

func _on_go_down_timer_timeout() -> void:
	state = States.MOVE_DOWN

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_active = false
