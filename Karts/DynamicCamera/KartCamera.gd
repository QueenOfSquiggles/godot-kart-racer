extends Spatial

export (NodePath) var VehicleNodePath

export (float) var TimeToCatchUpPosition := 1.0 / 5.0
export (float) var LerpAngleSpeed := deg2rad(45.0)

var vehicle_node : VehicleBody

func _ready() -> void:
	vehicle_node = get_node(VehicleNodePath) as VehicleBody
	assert(vehicle_node, "Assign the vehicle node in the KartCamera!!!")
	self.set_as_toplevel(true)

func _process(delta: float) -> void:
	self.transform.origin = transform.origin.linear_interpolate(vehicle_node.transform.origin, (1.0 / TimeToCatchUpPosition) * delta)
	
	var start := rotation.y
	var target := vehicle_node.rotation.y
	var lerp_speed := LerpAngleSpeed
	""" Turn Looking Logic
	if vehicle_node.steering != 0.0:
		# look towards the angle we are turning
		target = rotation.y + sign(vehicle_node.steering) * deg2rad(70.0)
		lerp_speed = 2.5
	"""
	rotation.y = lerp_angle(start, target, lerp_speed * delta)
	# match other rotation
	
	#rotation.x  = vehicle_node.rotation.x # rocking back and forth (front-back)
	# rotation.y  = vehicle_node.rotation.z #rolling (sides
