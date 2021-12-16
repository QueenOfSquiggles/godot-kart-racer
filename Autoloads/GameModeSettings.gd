extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - -
#		Swap Mem Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - -

var map_packed_scene : PackedScene
var player_count := 1
const MultiplayerScene := preload("res://LocalMultiplayer/SplitscreenMultiplayer.tscn")

# - - - - - - - - - - - - - - - - - - - - - - - - - -


# -1 = forwards, 1 = backwards
var track_direction := -1
# m/s/s acceleration for the karts to use.
var kart_acceleration := 50.0
# whether to use rubber banding or not
var use_rubber_banding := true
# the max number of speed boost levels a grind can provide. -1 for infinite
var max_speed_boost_increments := 3


const GAME_MODE_SETTINGS_DIR := "user://game_modes/"

func save_settings(file_name : String) -> void:
	_ensure_folder()
	var file := File.new()
	file.open(GAME_MODE_SETTINGS_DIR + file_name, File.WRITE)
	var json_data = to_json(_get_save_dict())
	file.store_line(json_data)
	file.close()

func _get_save_dict()-> Dictionary:
	return {
		"track_direction" : track_direction,
		"kart_acceleration" : kart_acceleration,
		"use_rubber_banding" : use_rubber_banding,
		"max_speed_boost_increments" : max_speed_boost_increments
	}

func load_settings(file_name : String) -> void:
	_ensure_folder()
	var file := File.new()
	if file.open(GAME_MODE_SETTINGS_DIR + file_name, File.READ):
		var json_data := file.get_as_text()
		var dict :Dictionary= parse_json(json_data)
		_load_from_dict(dict)
	file.close()

func _load_from_dict(import_data : Dictionary) -> void:
	track_direction = import_data.track_direction
	kart_acceleration = import_data.kart_acceleration
	use_rubber_banding = import_data.use_rubber_banding
	max_speed_boost_increments = import_data.max_speed_boost_increments

func _ensure_folder() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(GAME_MODE_SETTINGS_DIR):
		dir.make_dir_recursive(GAME_MODE_SETTINGS_DIR)
