extends Track

onready var anim := $AnimPlayer

func _ready() -> void:
	anim.play("Opening")
