extends StaticBody2D

class_name BossWall

@export var my_col: CollisionShape2D = null

func set_col_disable(dis_query: bool) -> void:
	if (my_col != null):
		my_col.disabled = dis_query
