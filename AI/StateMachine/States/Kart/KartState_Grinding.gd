extends Node

export (NodePath) var KartNode

export (float) var time_increment := 1.5
export (float) var speed_factor_per_increment := 0.75
export (float) var grind_turn_angle := 25.0

onready var timer : Timer = $Timer

var fsm : StateMachine
var kart : KCC_Kart

var initial_speed : float
var speed_boost_level : int = 0
var turn_angle : float = 0.0

func _ready() -> void:
	timer.connect("timeout", self, "timer_timeout")
	kart = get_node(KartNode)
	assert(kart, "Assign the KartNode in " + name)

func enter() -> void:
	initial_speed = kart.ball.linear_velocity.length()
	turn_angle = sign(kart.rotate_input) * deg2rad(grind_turn_angle)
	if turn_angle == 0:
		exit()
		return
	timer.call_deferred("start", time_increment)

func physics_process(delta: float) -> void:
	if kart.on_ground:
		rotate(delta)
#		kart.ball.add_central_force(-kart.car_mesh.global_transform.basis.z * kart.speed_input)
		kart.ball.linear_velocity = -kart.car_mesh.global_transform.basis.z * initial_speed
	if not kart.is_grinding:
		exit()


func rotate(delta : float) -> void:
	var new_basis = kart.car_mesh.global_transform.basis.rotated(kart.car_mesh.global_transform.basis.y, turn_angle)
	kart.car_mesh.global_transform.basis = kart.car_mesh.global_transform.basis.slerp(new_basis, kart.turn_speed * delta)
	kart.car_mesh.global_transform = kart.car_mesh.global_transform.orthonormalized()

func timer_timeout() -> void:
	if GameModeSettings.max_speed_boost_increments == -1 or GameModeSettings.max_speed_boost_increments < max_increments:
		speed_boost_level += 1
		print("Speed Boost Level : " + str(speed_boost_level))
	else:
		timer.stop()

func exit() -> void:
	var speed_boost : float = 0.0
	speed_boost = float(speed_boost_level) * (speed_factor_per_increment * GameModeSettings.kart_acceleration)
	kart.ball.apply_central_impulse(-kart.car_mesh.global_transform.basis.z * speed_boost)
	timer.stop()
	speed_boost_level = 0
	fsm.back()
