extends Node2D

class_name EnemyManager

func _ready() -> void:
	for child in get_children():
		if (child is Enemy):
			connect_poof(child)
			
			if (child is Kaboom):
				connect_explosion(child)
			elif (child is Twister):
				connect_head(child)
			elif (child is Puddle or child is Sweed):
				connect_mouthbreaker(child)
			elif (child is Threebie):
				connect_threebie_head(child)

func inject_player(player: Player) -> void:
	for child in get_children():
		if (child is SmartEnemy):
			child.player = player

func connect_poof(my_enemy: Enemy) -> void:
	my_enemy.created_poof.connect(add_poof)

func connect_explosion(my_kaboom: Kaboom) -> void:
	my_kaboom.created_explosion.connect(add_explosion)

func connect_head(my_twister: Twister) -> void:
	my_twister.created_head.connect(add_head)

func connect_mouthbreaker(my_enemy: Enemy) -> void:
	my_enemy.created_mouthbreaker.connect(add_mouthbreaker)

func connect_threebie_head(my_threebie: Threebie) -> void:
	my_threebie.created_head.connect(add_threebie_head)

func add_poof(poof: Poof) -> void:
	add_child(poof)

func add_explosion(explosion: Explosion) -> void:
	add_child(explosion)

func add_head(head: TwisterHead) -> void:
	add_child(head)

func add_mouthbreaker(mouthbreaker: Mouthbreaker) -> void:
	add_child(mouthbreaker)

func add_threebie_head(head: ThreebieHead) -> void:
	connect_poof(head)
	add_child(head)
