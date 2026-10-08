extends Node2D

class_name CamPoint

signal player_reached()

@export var cam_enter_right: bool = false
@export var cam_enter_left: bool = false
@export var cam_leave_right: bool = false
@export var cam_leave_left: bool = false

var cam: Cam = null
var player: Player = null

func _process(_delta: float) -> void:
	if (cam != null):
		if (cam.position.y == position.y):
			if (cam.target != self):
				if (cam_enter_right):
					if (cam.position.x >= position.x):
						if (cam.target is Player):
							player = cam.target
						cam.target = self
						player_reached.emit()
				elif (cam_enter_left):
					if (cam.position.x <= position.x):
						if (cam.target is Player):
							player = cam.target
						cam.target = self
						player_reached.emit()
			else:
				if (player != null):
					if (cam_leave_left):
						if (player.position.x < position.x):
							cam.target = player
							player = null
					elif (cam_leave_right):
						if (player.position.x > position.x):
							cam.target = player
							player = null
