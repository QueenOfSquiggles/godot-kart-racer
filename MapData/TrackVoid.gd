extends Area


func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("kart") and body.get_parent().has_method("trigger_kart_fell_off_track"):
		body.get_parent().trigger_kart_fell_off_track()
	else:
		print("failed to get reset pos method")


