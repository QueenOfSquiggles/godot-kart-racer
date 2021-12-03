extends PanelContainer

export (NodePath) var PlayerKartNode

onready var tween : Tween = $Tween

var player_kart : Spatial

var start_x : float

func _ready() -> void:
	player_kart = get_node(PlayerKartNode)
	assert(player_kart, "Assign the PlayerKartNode in the LevelMenu to allow for changing settings on the fly!")
	_set_speed(50.0)
	start_x = rect_position.x

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_toggle_level_menu"):
		if visible:
			hide()
		else:
			display()

func display() -> void:
	visible = true
	_move(start_x + rect_size.x, start_x)

func hide() -> void:
	yield(_move(start_x, start_x + rect_size.x), "completed")
	visible = false

func _move(start : float, end: float) -> void:
	tween.stop_all()
	tween.interpolate_property(self, "rect_position:x", start, end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")







func _on_BtnMainMenu_pressed() -> void:
	get_tree().change_scene("res://Menues/MainMenu.tscn")

func _on_BtnSpeed_25_pressed() -> void:
	_set_speed(25.0)


func _on_BtnSpeed_50_pressed() -> void:
	_set_speed(50.0)

func _on_BtnSpeed_75_pressed() -> void:
	_set_speed(75.0)

func _on_BtnSpeed_100_pressed() -> void:
	_set_speed(100.0)

func _set_speed(metres_per_second : float) -> void:
	player_kart.acceleration = metres_per_second
