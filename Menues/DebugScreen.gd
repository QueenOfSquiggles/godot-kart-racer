extends PanelContainer

export (NodePath) var PlayerKartNode

var player_kart : Spatial
var ball : RigidBody


onready var label_input_speed :Label = $VBoxContainer/Lbl_Input_Speed
onready var label_input_turn :Label = $VBoxContainer/Lbl_Input_Turn
onready var label_velocity :Label = $VBoxContainer/Lbl_Velocity
onready var label_speed :Label = $VBoxContainer/Lbl_Speed
onready var label_speed_km :Label = $VBoxContainer/Lbl_Speed_km_h
onready var label_on_ground :Label = $VBoxContainer/Lbl_OnGround
onready var label_is_grinding :Label = $VBoxContainer/Lbl_IsGrinding



func _ready() -> void:
	player_kart = get_node(PlayerKartNode)
	assert(player_kart, "Assign the PlayerKartNode in the DebugScreen node")
	ball = player_kart.find_node("Ball") as RigidBody
	assert(ball, "Failed to find the 'Ball' node on the provided PlayerKartNode")
	$UISlide.call_deferred("hide")


func _process(delta: float) -> void:
	# update values
	label_input_speed.text = "Speed Input : " + str(player_kart.speed_input) + "m/s"
	label_input_turn.text = "Rotation Input : " + str(rad2deg(player_kart.rotate_input))
	label_velocity.text = "Velocity : " + str(ball.linear_velocity)
	label_speed.text = "Speed : " + str(ball.linear_velocity.length())
	# 1 m/s = 3.6 km/h -->
	label_speed_km.text = "Speed : " + str(floor(ball.linear_velocity.length() * 3.6)) + "km/h"
	label_on_ground.text = "On Ground = " + str(player_kart.on_ground)
	label_is_grinding.text = "Is Grinding = " + str(player_kart.is_grinding)
