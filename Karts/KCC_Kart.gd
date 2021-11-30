extends Spatial

onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
onready var wheel_front_left := $CarMesh/tmpParent/race/wheel_frontLeft
onready var wheel_front_right := $CarMesh/tmpParent/race/wheel_frontRight


onready var label_input_speed :Label = $PanelContainer/VBoxContainer/Lbl_Input_Speed 
onready var label_input_turn :Label = $PanelContainer/VBoxContainer/Lbl_Input_Turn 
onready var label_velocity :Label = $PanelContainer/VBoxContainer/Lbl_Velocity
onready var label_speed :Label = $PanelContainer/VBoxContainer/Lbl_Speed
onready var label_on_ground :Label = $PanelContainer/VBoxContainer/Lbl_OnGround

# Where to place the car mesh relative to sphere
var sphere_offset := Vector3(0, -1.0, 0)
# engine power
export var acceleration := 50.0
# turn amount in degrees
export var steering := 21.0
# how quickly the car turns
export var turn_speed := 5.0
# below this speed it cannot turn
export  var turn_stop_limit := 0.75

export var body_tilt := 35.0

var speed_input = 0.0
var rotate_input = 0.0
var on_ground := false

func _ready() -> void:
	ground_ray.add_exception(ball)

func _physics_process(_delta: float) -> void:
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	if on_ground:
		ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)

func _process(delta: float) -> void:
	update_debug()
	var n:Vector3 = Vector3.UP

	on_ground = ground_ray.is_colliding()
	n = ground_ray.get_collision_normal()
	speed_input = 0
	speed_input += Input.get_action_strength("move_forwards")
	speed_input -= Input.get_action_strength("move_back")
	speed_input *= acceleration
	
	rotate_input = 0
	rotate_input += Input.get_action_strength("move_left")
	rotate_input -= Input.get_action_strength("move_right")
	rotate_input *= deg2rad(steering)
	
	wheel_front_left.rotation.y = rotate_input + deg2rad(180.0)
	wheel_front_right.rotation.y = rotate_input

	if on_ground and ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, 10 * delta)
	# align to ground
	var xform := align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform.orthonormalized(), 10 * delta)
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized()

func align_with_y(xform : Transform, new_y : Vector3) -> Transform:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func update_debug():
	label_input_speed.text = "Speed Input : " + str(speed_input)
	label_input_turn.text = "Rotation Input : " + str(rotate_input)
	label_velocity.text = "Velocity : " + str(ball.linear_velocity)
	label_speed.text = "Speed : " + str(ball.linear_velocity.length())
	label_on_ground.text = "On Ground = " + str(on_ground)
