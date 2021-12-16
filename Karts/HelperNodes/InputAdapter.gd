extends Node
class_name InputAdapter
"""
An adapter that makes taking input from a specific device easier than is built-in
Not the best solution but it works

"""
export var device := -1

signal device_input_event(InputEvent)

	
func get_action_strength(name:String) -> float:
	return Input.get_action_strength(name+str(device))

func is_action_pressed(name:String) -> bool:
	return Input.is_action_pressed(name+str(device))

func is_action_just_pressed(name:String) -> bool:
	return Input.is_action_just_pressed(name+str(device))

func is_action_just_released(name:String) -> bool:
	return Input.is_action_just_released(name+str(device))

"""
This seems to be unecessary for how I'm making this game. Still good for other games though

func get_axis(negative:String, positive: String) -> float:
	return Input.get_axis(negative+str(device), positive+str(device))

func get_vector(negx : String, posx : String, negy : String, posy : String) -> Vector2:
	return Input.get_vector(negx+str(device), posx+str(device), negy+str(device), posy+str(device))

func _input(event: InputEvent) -> void:
	if event.device == device:
		emit_signal("device_input_event", event)
"""
