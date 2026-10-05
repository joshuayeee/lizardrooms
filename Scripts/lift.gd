extends Enemy

class_name Lift

@onready var move_com: MoveCom = $Components/MoveCom
@onready var gravity_com: GravityCom = $Components/GravityCom
@onready var jump_com: JumpCom = $Components/JumpCom
@onready var anim_com: AnimCom = $Components/AnimCom
@onready var hurt_timer: Timer = $HurtTimer

var direction: float = -1.0

enum States {BOUNCING, CRAWLING}
var state: States = States.BOUNCING

var can_hurt: bool = true

func _physics_process(delta: float) -> void:
	if (Global.game_active):
		gravity_com.handle_gravity(delta)
		
		if (is_active):
			move_com.handle_hori_move(direction)
			if (state == States.BOUNCING):
				jump_com.handle_jump(is_on_floor())
				anim_com.handle_animation(direction,
											is_on_floor(),
											"bounce",
											"bounce",
											"bounce")
			else:
				anim_com.handle_animation(direction,
											is_on_floor(),
											"crawl",
											"crawl",
											"crawl")
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func hurt() -> void:
	can_hurt = false
	hurt_timer.start()
	if (state == States.BOUNCING):
		state = States.CRAWLING
	elif (state == States.CRAWLING):
		poof_death()

func _on_left_check_body_entered(_body: Node2D) -> void:
	if (direction < 0):
		direction = 1.0

func _on_right_check_body_entered(_body: Node2D) -> void:
	if (direction > 0):
		direction = -1.0

func _on_player_check_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (Global.game_active and is_active and not body.has_cupcake and can_hurt):
			body.hurt()
		elif (body.has_cupcake):
			hurt()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_active = true

func _on_hurt_timer_timeout() -> void:
	can_hurt = true
