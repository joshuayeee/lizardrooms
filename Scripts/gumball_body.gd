extends AnimatableBody2D

class_name GumballBody

var gumball: Gumball = null

func _process(_delta: float) -> void:
	if (Global.game_active):
		if (gumball != null):
			global_position = gumball.global_position

func set_gumball(my_gumball: Gumball) -> void:
	gumball = my_gumball
	gumball.request_destroy.connect(handle_destroy)

func handle_destroy() -> void:
	if (gumball != null):
		gumball.call_deferred("queue_free")
		call_deferred("queue_free")
