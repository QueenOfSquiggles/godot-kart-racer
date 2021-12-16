extends Control
class_name Splitscreen

onready var map_root :Spatial = $Map
onready var screen_container :GridContainer = $VBoxContainer

var current_map : Track = null

const PlayerScreen := preload("res://LocalMultiplayer/PlayerViewport.tscn")


func _ready() -> void:
	_clear_map()
	load_map(GameModeSettings.map_packed_scene)

func _clear_map() -> void:
	var children := map_root.get_children()
	for c in children:
		map_root.remove_child(c)

func load_map(map_scene : PackedScene) -> void:
	current_map = map_scene.instance()
	assert(current_map, "failed to load map scene")
	current_map.connect("level_loading_completed", self, "on_level_ready")
	map_root.add_child(current_map)


func on_level_ready() -> void:
	print("Level loading completed. Adding players and player screens")
	screen_container.columns = get_num_columns_for_player_count(GameModeSettings.player_count)
	for i in range(GameModeSettings.player_count):
		var kart :Spatial= current_map.player_kart.instance()
		current_map.add_kart(kart)
		var cam = kart.camera
		kart.player_num = i
		cam.get_parent().remove_child(cam)
		add_player_screen(kart, cam)

func get_num_columns_for_player_count(count : int) -> int:
	return int(sqrt(1.5*float(count)))

func add_player_screen(kart : KCC_Kart, cam : Spatial) -> void:
	var screen := PlayerScreen.instance()
	screen.get_child(0).add_child(cam)
	screen_container.add_child(screen)
