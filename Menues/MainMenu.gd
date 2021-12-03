extends VBoxContainer

export (PackedScene) var ScenePlayground
export (PackedScene) var SceneClosedCourse
export (PackedScene) var SceneFallingTrack

func _on_BtnPlayground_pressed() -> void:
	_change_scene(ScenePlayground)


func _on_BtnClosedCourse_pressed() -> void:
	_change_scene(SceneClosedCourse)

func _on_BtnFallingTrack_pressed() -> void:
	_change_scene(SceneFallingTrack)

func _change_scene(scene_pack : PackedScene) -> void:
	get_tree().change_scene(scene_pack.resource_path)
