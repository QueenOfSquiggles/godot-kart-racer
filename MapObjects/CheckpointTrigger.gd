extends Spatial
class_name CheckpointTrigger

export (NodePath) var PreviousCheckpoint : NodePath
export (bool) var is_start := false

const CheckpointTrackerScene := preload("res://MapObjects/CheckpointTracker.tscn")
const notification := preload("res://UI/notification/PopupNotification.tscn")

onready var lap_timer := $LapTimer

var last_checkpoint_node : Spatial

func _ready() -> void:
	last_checkpoint_node = get_node(PreviousCheckpoint)

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("kart"):
		var root :Spatial = body.get_parent()
		var tracker :CheckpointTracker = root.get_node("CheckpointTracker")
		if is_start and not tracker:
			var t :CheckpointTracker = CheckpointTrackerScene.instance()
			root.add_child(t)
			do_checkpoint(t)
		elif tracker:
			var lcp := tracker.last_checkpoint.name
			var test := last_checkpoint_node.name
			if lcp == test:
				# we are good, use checkpoint
				do_checkpoint(tracker)
			elif not lcp == self.name:
				# only notify wrong order if it's a different checkpoint
				# on the same checkpoint it would be weird to get a wrong order notification
				notify("WRONG ORDER")
				var rb := body as RigidBody
				rb.linear_velocity = Vector3.ZERO
				rb.global_transform.origin = tracker.last_checkpoint.global_transform.origin
		else:
			notify("Something went wrong")

func do_checkpoint(tracker : CheckpointTracker) -> void:
	tracker.last_checkpoint = self
	if is_start:
		lap_timer.on_lap()
	else:
		notify("Still good! :D")

func notify(text : String)->void:
	var i := notification.instance()
	i.notification_text = text
	i.notification_duration = 1.5
	add_child(i)
