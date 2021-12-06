tool
extends Spatial

enum Direction {
	Forwards, Backwards
}

export (Direction) var TrackDirection := Direction.Forwards

var dir := -1

func _ready() -> void:
	call_deferred("do_setup")

func do_setup() -> void:
	dir = -1 if TrackDirection== Direction.Forwards else 1
	var children := get_children()
	var count := get_child_count()

	for i in range(count):
		var checkpoint :Spatial= children[i]
		# weird math makes sure it wraps properly
		var previous_index := get_connected_index(i, count)
		var previous :Spatial = children[previous_index]
		checkpoint.PreviousCheckpoint = checkpoint.get_path_to(previous)
		checkpoint.last_checkpoint_node = previous
		checkpoint.is_start = false

	children[0].is_start = true

func get_connected_index(i : int, count : int ) -> int:
	return (i + count + dir) % count
