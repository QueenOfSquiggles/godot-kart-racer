extends ViewportContainer


var cam : Camera

func setup() -> void:
	cam = $Viewport/Camera 
	assert(cam, "failed to find camera within the player viewport")
