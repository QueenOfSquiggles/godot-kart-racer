extends AspectRatioContainer

var map_scene : PackedScene

func set_scene(scene : PackedScene) -> void:
	map_scene = scene
	$PanelContainer/VBoxContainer/Label.text = scene.resource_name

func _on_Button_pressed() -> void:
	GameModeSettings.map_packed_scene = map_scene
	get_tree().change_scene_to(GameModeSettings.MultiplayerScene)
