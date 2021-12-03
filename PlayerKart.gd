extends "res://Karts/KCC_Kart.gd"

func get_input() -> void:
	speed_input = 0
	speed_input += Input.get_action_strength("move_forwards")
	speed_input -= Input.get_action_strength("move_back")
	speed_input *= acceleration

	rotate_input = 0
	rotate_input += Input.get_action_strength("move_left")
	rotate_input -= Input.get_action_strength("move_right")
	rotate_input *= deg2rad(steering)
