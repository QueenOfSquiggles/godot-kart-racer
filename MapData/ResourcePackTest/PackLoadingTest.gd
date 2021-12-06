extends Node

export (String) var resource_path := "imported_maps/"

onready var list : VBoxContainer = $VBoxContainer

const ResourcesRootPath := "user://"

var pack_files := []

func _ready() -> void:
	var dir := Directory.new()
	var path := ResourcesRootPath + resource_path

	if not dir.dir_exists(path):
		dir.make_dir_recursive(path)

	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		print(dir.get_current_dir())
		var file_name := dir.get_next()
		while file_name != "":
			print("Found : " + file_name)
			if file_name.ends_with(".pck"):
				# it's a pack file
				print("Found a pack file!!!!")
				pack_files.append(file_name)
			file_name = dir.get_next()
	else:
		assert(false, "failed to open import maps folder!")
	print(pack_files)
	add_pack_buttons()

func add_pack_buttons():
	for file_name in pack_files:
		var btn := _create_button(ResourcesRootPath + resource_path + file_name)
		list.add_child(btn)

func _create_button(pack_file_path : String) -> Button:
	var btn := Button.new()
	btn.text = "Load -> " + pack_file_path
	btn.connect("pressed", self, "load_pack_btn_pressed", [pack_file_path])
	return btn

func load_pack_btn_pressed(pack_file_path : String) -> void:
	print("Attempting to load pack file: ", pack_file_path)
	var success := ProjectSettings.load_resource_pack(pack_file_path, false)
	if success:
		var imported_scene := load("res://MapData/TrackSpeedrun.tscn")
		if imported_scene:
			var inst = imported_scene.instance()
			add_child(inst)
			list.queue_free()
