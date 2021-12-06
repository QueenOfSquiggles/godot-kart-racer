extends Node

const NotificationScene := preload("res://UI/notification/PopupNotification.tscn")

var last_time := -1

func on_lap() -> void:
	print("Doing lap!")
	if last_time < 0:
		last_time = OS.get_unix_time()
		return
	var delta := OS.get_unix_time() - last_time
	var minutes := delta / 60
	var seconds := delta % 60
	var str_time := "%02d : %02d" % [minutes, seconds]

	var n := NotificationScene.instance()
	n.notification_text = "Lap Time: " + str_time
	n.notification_duration = 3.0
	add_child(n)
	print(str_time)

	# reset for next lap
	last_time = OS.get_unix_time()
