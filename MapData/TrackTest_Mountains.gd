extends Track

onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("Opening")
