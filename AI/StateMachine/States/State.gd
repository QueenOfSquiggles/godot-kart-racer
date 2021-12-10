extends Node

class_name State

var fsm : StateMachine

func enter() -> void:
	# do state enter logic
	# for example, we will just do a timer then exit
	yield(get_tree().create_timer(0.2), "timeout")
	exit("State2") # requires another state node called "State2"

func exit(next_state : String) -> void:
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta : float) -> float:
	# Add handler code here
	return delta

func physics_process(delta : float) -> float:
	return delta

func input(event : InputEvent) -> InputEvent:
	return event

func unhandled_input(event : InputEvent) -> InputEvent:
	return event

func unhandled_key_input(event : InputEvent) -> InputEvent:
	return event

func notification(what, flag = false) -> void:
	pass
	#return [what, flag]
