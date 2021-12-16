extends "res://Karts/KCC_Kart.gd"

onready var input : InputAdapter = $InputAdapter 
var player_num := -1

func get_input() -> void:
	if player_num < 0:
		return
	if input.device < 0:
		input.device = player_num
	speed_input = 0
	speed_input += input.get_action_strength("move_forwards")
	speed_input -= input.get_action_strength("move_back")
	speed_input *= GameModeSettings.kart_acceleration

	rotate_input = 0
	rotate_input += input.get_action_strength("move_left")
	rotate_input -= input.get_action_strength("move_right")
	rotate_input *= deg2rad(steering)

	is_grinding = input.is_action_pressed("grind")
