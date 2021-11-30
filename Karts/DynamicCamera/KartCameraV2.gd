extends Spatial

export (NodePath) var PositionSourcePath
export (NodePath) var RotationSourcePath
export (NodePath) var ExcludePhysicsBodyPath
export (float) var PositionLerpSpeed := 1.0
export (float) var RotationLerpSpeed := 1.0

export var LockToKart := false

onready var arm : SpringArm = $SpringArm

var position_source : Spatial
var rotation_source : Spatial

func _ready() -> void:
	var body : RigidBody = get_node(ExcludePhysicsBodyPath)
	assert(body, "assign the rigid body to exclude")
	arm.add_excluded_object(body.get_rid())
	
	self.set_as_toplevel(true)
	position_source = get_node(PositionSourcePath)
	rotation_source = get_node(RotationSourcePath)
	
	assert(position_source, "Assign the positional source in the kart cam v2")
	assert(rotation_source, "Assign the rotational source in the kart cam v2")
	
	global_transform = position_source.global_transform
	
func _process(delta: float) -> void:
	if LockToKart:
		transform.origin = position_source.global_transform.origin
		var rot := rotation_source.rotation
		rot.z = 0.0
		rotation = rot
	else:
		var delta_pos := position_source.transform.origin - transform.origin
		var distance_factor = max(delta_pos.length() / 1.0, 1.0) # create export var here
		
		var pos := transform.origin
		var pos_target := position_source.transform.origin
		transform.origin = do_lerp(pos, pos_target, PositionLerpSpeed * distance_factor * delta)
		
		var target_rotation := rotation_source.rotation
		var theta := -rotation_dot(target_rotation.y, rotation.y)
		var theta_factor := max(1.0, theta / 0.25) # another export var here later
		
		rotation.y = lerp_angle(rotation.y, target_rotation.y, RotationLerpSpeed * theta_factor * delta)

func rotation_dot(a : float, b : float) -> float:
	var vec_a := Vector2(cos(a), sin(a))
	var vec_b := Vector2(cos(b), sin(b))
	return vec_a.dot(vec_b)


func do_lerp(start : Vector3, target : Vector3, factor : float) -> Vector3:
	return start.linear_interpolate(target, factor)
