extends AspectRatioContainer

var label : Label
var map_scene : PackedScene

func set_scene(scene : PackedScene) -> void:
	
	map_scene = scene
	label = $PanelContainer/VBoxContainer/Label
	var temp := map_scene.instance()
	label.text = temp.name
	temp.queue_free()

func _on_Button_pressed() -> void:
	GameModeSettings.map_packed_scene = map_scene
	get_tree().change_scene_to(GameModeSettings.MultiplayerScene)
