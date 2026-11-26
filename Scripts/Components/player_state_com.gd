extends Node

class_name PlayerStateCom

enum States {NORMAL, SANDWICH, CANDY, CUPCAKE}

func get_state_name(state: States) -> String:
	match state:
		States.SANDWICH:
			return "sandwich"
		States.CANDY:
			return "candy"
		States.CUPCAKE:
			return "cupcake"
		_:
			return "normal"
