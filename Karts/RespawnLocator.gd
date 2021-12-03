extends Spatial

export (float) var refresh_time := 0.5
export (NodePath) var PositionSetNode
export (NodePath) var RaycastNode

onready var timer : Timer = $Timer

var raycast : RayCast
var pos_set_node : Spatial
var last_position : Vector3

func _ready() -> void:
	pos_set_node = get_node(PositionSetNode)
	assert(pos_set_node, "Assign the PositionSetNode in the RespawnLocator")
	raycast = get_node(RaycastNode)
	assert(raycast, "Assign RaycastNode in RespawnLocator")
	var _t = timer.connect("timeout", self, "refresh")
	refresh()

func refresh() -> void:
	if raycast.is_colliding():
		last_position = pos_set_node.global_transform.origin
	timer.start(refresh_time)

func reset_position() -> void:
	print("Resetting kart position")
	pos_set_node.global_transform.origin = last_position
	if pos_set_node is RigidBody:
		(pos_set_node as RigidBody).linear_velocity = Vector3.ZERO
