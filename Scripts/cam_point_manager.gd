extends Node2D

class_name CamPointManager

func connect_points_to_cam(cam: Cam) -> void:
	for child in get_children():
		child.cam = cam
