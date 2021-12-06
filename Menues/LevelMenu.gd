extends PanelContainer

export (NodePath) var PlayerKartNode

var player_kart : Spatial

func _ready() -> void:
	player_kart = get_node(PlayerKartNode)
	assert(player_kart, "Assign the PlayerKartNode in the LevelMenu to allow for changing settings on the fly!")
	_set_speed(50.0)
	$UISlide.call_deferred("hide")

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
