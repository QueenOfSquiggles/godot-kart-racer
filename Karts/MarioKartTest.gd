extends VehicleBody

# I want to accelerate & decelerate within bounds. No reverse, just forwards motion and braking

export var TurnAngle := deg2rad(15.0)
export var AccelerationForce := 200.0
export var BrakingForce := 5.0

onready var label_engine :Label = $DebugData/VBoxContainer/Lbl_EngineForce
onready var label_braking :Label = $DebugData/VBoxContainer/Lbl_Braking
onready var label_steering :Label = $DebugData/VBoxContainer/Lbl_Steering
onready var label_velocity :Label = $DebugData/VBoxContainer/Lbl_Velocity
onready var label_speed :Label = $DebugData/VBoxContainer/Lbl_Speed

func _process(delta: float) -> void:
	# assign labels
	label_engine.text = "Engine Force : " + str(engine_force)
	label_braking.text = "Braking : " + str(brake)
	label_steering.text = "Steering : " + str(steering)
	label_velocity.text = "Linear Velocity : " + str(linear_velocity)
	label_speed.text = "Speed : " + str(linear_velocity.length())
	

func _physics_process(delta: float) -> void:
	get_input()

func get_input():
	var motion : Vector2 = Input.get_vector("move_right", "move_left", "move_back", "move_forwards")
	steering = motion.x * TurnAngle
	if abs(motion.y) <= 0.01:
		engine_force = 0
	else:
		engine_force = motion.y * AccelerationForce
