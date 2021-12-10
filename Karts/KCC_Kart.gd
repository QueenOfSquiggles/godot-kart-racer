extends Spatial

class_name KCC_Kart

onready var ball :RigidBody= $Ball
onready var car_mesh :Spatial= $CarMesh
onready var ground_ray :RayCast= $CarMesh/RayCast
onready var wheel_front_left :Spatial= $CarMesh/tmpParent/race/wheel_frontLeft
onready var wheel_front_right :Spatial= $CarMesh/tmpParent/race/wheel_frontRight

onready var respawn_locator := $RespawnLocator

signal on_kart_fell_off_track

# Where to place the car mesh relative to sphere
var sphere_offset := Vector3(0, -1.0, 0)
# engine power
# turn amount in degrees
export var steering := 21.0
# how quickly the car turns
export var turn_speed := 5.0
# below this speed it cannot turn
export  var turn_stop_limit := 0.75

export var body_tilt := 35.0

export var grind_turn_angle := deg2rad(45.0)

var speed_input = 0.0
var rotate_input = 0.0
var on_ground := false
var is_grinding := false

func _ready() -> void:
	ground_ray.add_exception(ball)

func _physics_process(_delta: float) -> void:
	car_mesh.transform.origin = ball.transform.origin + sphere_offset

func get_input() -> void:
	"""
	Override for implementation.
		Use Input for local/player cars
		Use AI for non-player cars
	"""
	speed_input = 0
	rotate_input = 0


func _process(delta: float) -> void:
	var n:Vector3 = Vector3.UP

	on_ground = ground_ray.is_colliding()
	n = ground_ray.get_collision_normal()

	get_input()

	wheel_front_left.rotation.y = rotate_input + deg2rad(180.0)
	wheel_front_right.rotation.y = rotate_input

	# align to ground
	var xform := align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	#car_mesh.global_transform = xform.orthonormalized()
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
	car_mesh.transform = car_mesh.transform.orthonormalized()

func align_with_y(xform : Transform, new_y : Vector3) -> Transform:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func trigger_kart_fell_off_track() -> void:
	emit_signal("on_kart_fell_off_track")
