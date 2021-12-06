extends PanelContainer


export (String) var notification_text := "test notification"
export (float) var notification_duration := 1.5

onready var slide := $UISlide
onready var label := $Label
onready var timer := $Timer

func _ready() -> void:
	self.visible = false
	label.text = notification_text
	slide.connect("on_display_complete", self, "start_timer")
	slide.display()

func start_timer() -> void:
	timer.connect("timeout", self, "on_timeout")
	timer.start(notification_duration)

func on_timeout()-> void:
	slide.connect("on_hide_complete", self, "destroy_self")
	slide.hide()

func destroy_self() -> void:
	call_deferred("queue_free")
