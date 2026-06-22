extends Control

@onready var label = $Label
@onready var time_label = $TimeLabel
@onready var button_sound: AudioStreamPlayer2D = $ButtonSound
func _ready():
	label.text = "Fruits collected:\n " + str(Global.points)

	var rounded_time: float = round(Global.time_alive * 10.0) / 10.0
	time_label.text = "Time survived(s):\n " + str(rounded_time) + "s"

func _on_restart_button_pressed():
	button_sound.play()
	Global.points = 0
	await button_sound.finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
