extends Node

var fsm : StateMachine

func enter() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	exit()

func exit() -> void:
	fsm.back()
