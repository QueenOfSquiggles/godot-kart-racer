extends "res://MapObjects/KartAffectorTile.gd"

export (float) var SpeedValue := 50.0
# should this set the speed to the value, or scale the current speed???
# setting to a fixed value would probably be easier to handle



func affect_kart(kart : RigidBody) -> void:
	# this keeps the direction, so this might be bad if the player is
	# driving backwards... maybe improve later?	
	kart.linear_velocity += -transform.basis.z.normalized() * SpeedValue
