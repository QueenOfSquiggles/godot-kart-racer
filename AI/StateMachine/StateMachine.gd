extends Node

class_name StateMachine

const DEBUG := false

var state
var history := []

func _ready() -> void:
	state = get_child(0)
	assert(state, "StateMachine needs State children")
	_enter_state()

func change_to(new_state : String) -> void:
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state() -> void:
	if DEBUG:
		print("Entering state : " + state.name)
	state.fsm = self
	state.enter()

func _process(delta : float) -> void:
	if state and state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state and state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if state and state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state and state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state and state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)
