extends VBoxContainer

export (Array, PackedScene) var BuiltInMaps := []

onready var map_grid : GridContainer = $GridContainer

const map_button := preload("res://LocalMultiplayer/MapSelectButton.tscn")

func _ready() -> void:
	for scene in BuiltInMaps:
		assert(scene is PackedScene, "BuiltInMaps only takes packed scenes! Don't use anything that isn't a packed scene!")
		var btn := map_button.instance()
		btn.map_scene = scene
		map_grid.add_child(btn)


func _on_BtnMainMenu_pressed() -> void:
	print("Main Menu button not yet implemented")
