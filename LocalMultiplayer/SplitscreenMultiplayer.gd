extends Control
class_name Splitscreen

onready var map_root :Spatial = $Map

func _ready() -> void:
	_clear_map()
	load_map(GameModeSettings.map_packed_scene)

func _clear_map() -> void:
	var children := map_root.get_children()
	for c in children:
		map_root.remove_child(c)

func load_map(map_scene : PackedScene) -> void:
	var map :Spatial = map_scene.instance()
	assert(map, "failed to load map scene")
	map_root.add_child(map)
	GameModeSettings
	
