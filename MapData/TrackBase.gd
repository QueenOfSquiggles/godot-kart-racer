extends Spatial
class_name Track

onready var player_spawn_min : Spatial = $PlayerSpawn
onready var checkpoint_group := $CheckpointGroup

var starting_checkpoint : Spatial
const player_kart := preload("res://Karts/PlayerKart.tscn")

var loaded_karts := []

signal level_loading_completed

func setup() -> void:
	starting_checkpoint = checkpoint_group.get_child(0)
	print("Doing setup")
	emit_signal("level_loading_completed")

func add_kart(kart : Spatial):
	var pos := get_rand_pos()
	kart.global_transform.origin = pos.global_transform.origin
	set_kart_direction(kart)
	add_child(kart)
	loaded_karts.append(kart)

func set_kart_direction(kart : Spatial) -> void:
	var delta := kart.global_transform.origin - starting_checkpoint.global_transform.origin
	kart.rotation.y = kart.rotation.angle_to(delta)
	
	#kart.look_at(starting_checkpoint.global_transform.origin, Vector3.UP)
	#kart.rotation_degrees.x = 0.0
	#kart.rotation_degrees.z = 0.0
	
func get_rand_pos() -> Position3D:
	var children = player_spawn_min.get_children()
	# this really assumes the objects are all Position3Ds
	return children[randi() % children.size()]
