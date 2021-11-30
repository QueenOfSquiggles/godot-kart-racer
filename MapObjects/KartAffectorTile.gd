extends Area

export (String) var AffectedGroupName := "kart"

func _ready() -> void:
	pass


func _on_KartAffector_body_entered(body: Node) -> void:
	if body.is_in_group(AffectedGroupName):
		if body is RigidBody:
			affect_kart(body as RigidBody)
		else:
			print("Unaffected rigid body entered affector. Name: " , body.name)


func affect_kart(kart : RigidBody) -> void:
	# override
	print("Affecting body : ", kart.name)
	

