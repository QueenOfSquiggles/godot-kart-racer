extends VehicleBody

export var STEER_SPEED := 1.5
export var STEER_LIMIT := 0.4


export var turn_speed_scale := 2.5
export var engine_force_value := 40.0

var steer_target := 0.0

var approx_flip_amount := 0.0


onready var label_engine : Label = $PanelContainer/DebugInfo/LblEngine
onready var label_brake : Label = $PanelContainer/DebugInfo/LblBrake
onready var label_steer : Label = $PanelContainer/DebugInfo/LblSteer
onready var label_velocity : Label = $PanelContainer/DebugInfo/LblVelocity
onready var label_speed : Label = $PanelContainer/DebugInfo/LblSpeed
onready var label_rotation : Label = $PanelContainer/DebugInfo/LblBodyRotation
onready var label_flip : Label = $PanelContainer/DebugInfo/LblFlipAmount

onready var flip_correction_point : Position3D = $FlipCorrectorPoint

func _ready() -> void:
	cam_arm.set_as_toplevel(true)
	cam_arm.rotation = Vector3.ZERO

func _process(delta: float) -> void:
	label_engine.text = "Engine : " + str(engine_force)
	label_brake.text = "Brake : " + str(brake)
	label_steer.text = "Steer : " + str(steering)
	label_velocity.text = "Linear Velocity : " + str(_round_vec(linear_velocity))
	label_speed.text = "Speed : " + str(linear_velocity.length())
	label_rotation.text = "Body Rotation (global) : " + str(rotation)
	label_flip.text = "Approximate Flip Amount : " + str(approx_flip_amount)

func _round_vec(vec : Vector3) -> Vector3:
	var r_vec : Vector3 = vec
	r_vec.x = round(r_vec.x)
	r_vec.y = round(r_vec.y)
	r_vec.z = round(r_vec.z)
	return r_vec

func _physics_process(delta: float) -> void:
	var fwd_mps := transform.basis.xform_inv(linear_velocity).x
	
	steer_target = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	steer_target *= STEER_LIMIT
	
	var engine := _engine_power()
	
	if Input.is_action_pressed("move_forwards"):
		# increase engine force at low speeds to make initial acceleration faster
		var speed := linear_velocity.length()
		if speed < 5.0 and speed != 0.0:
			engine_force = max(engine * 5 / speed, 0)
		else:
			engine_force = engine
	else:
		engine_force = 0.0
	
	if Input.is_action_pressed("move_back"):
		if fwd_mps >= -1:
			var speed = linear_velocity.length()
			if speed < 5.0 and speed != 0.0:
				engine_force = -max(engine * 5 / speed, 0)
			else:
				engine_force = -engine
		else:
			brake = 1.0
	else:
		brake = 0.0
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
	
	handle_cam_arm(delta)
	save_from_flips(delta)
	
func handle_cam_arm(delta : float) -> void:
	
	var time_delay := 1.0 / 5.0 # delay one fifth of a second
	# lerp so that it takes $time_delay to reach the current position (smaller time delay makes more realtime)
	cam_arm.transform.origin = cam_arm.transform.origin.linear_interpolate(self.transform.origin, (1.0 / time_delay) * delta)
	
	var start := cam_arm.rotation.y
	var target := start
	var lerp_speed := 0.5
	if steer_target != 0.0:
		# look towards the angle we are turning
		target = rotation.y + sign(steer_target) * deg2rad(70.0)
		lerp_speed = 2.5
	else:
		# lerp back to normal -> looking forwards
		target = rotation.y
	cam_arm.rotation.y = lerp_angle(start, target, lerp_speed * delta)
	# match other rotation
	cam_arm.rotation.x  = self.rotation.x # rocking back and forth (front-back)
	# cam_arm.rotation.y  = self.rotation.z #rolling (sides

func save_from_flips(delta : float) -> void:
	var sample : Vector3 = transform.basis.y
	approx_flip_amount = max(sample.dot(Vector3.DOWN), 0.0)
	if approx_flip_amount >= 0.8 and linear_velocity.length_squared() < 0.1:
		# pretty sure we are flipped and not moving enough to correct
		# do corrective flip
		self.apply_impulse(flip_correction_point.transform.origin, Vector3.UP * self.mass * 3)
	
func _engine_power() -> float:
	if abs(steering) > 0.1:
		return engine_force_value * turn_speed_scale
	return engine_force_value
	
