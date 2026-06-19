extends Control

@onready var label = $Label
@onready var time_label = $TimeLabel

func _ready():
	label.text = "Score: " + str(Global.points)
	time_label.text = "Time: " + str(round(Global.time_alive)) + "s"

func _on_restart_button_pressed():
	Global.points = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
