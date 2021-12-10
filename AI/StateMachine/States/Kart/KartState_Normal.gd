extends Node
export (NodePath) var KartNode

var fsm : StateMachine
var kart : KCC_Kart

func _ready() -> void:
	kart = get_node(KartNode)
	assert(kart, "Assign the KartNode in " + name)

func enter() -> void:
	# not really anything needed
	pass

func physics_process(delta: float) -> void:
	if kart.on_ground:
		kart.ball.add_central_force(-kart.car_mesh.global_transform.basis.z * kart.speed_input)
		if kart.ball.linear_velocity.length() > kart.turn_stop_limit:
			var new_basis = kart.car_mesh.global_transform.basis.rotated(kart.car_mesh.global_transform.basis.y, kart.rotate_input)
			kart.car_mesh.global_transform.basis = kart.car_mesh.global_transform.basis.slerp(new_basis, kart.turn_speed * delta)
			kart.car_mesh.global_transform = kart.car_mesh.global_transform

			var t = -kart.rotate_input * kart.ball.linear_velocity.length() / kart.body_tilt
			kart.car_mesh.rotation.z = lerp(kart.car_mesh.rotation.z, t, 10 * delta)

func process(delta: float) -> void:
	if kart.is_grinding:
		fsm.change_to("KartState_Grinding")
