extends Control

var transitioning: bool = false

@onready var button_sound: AudioStreamPlayer2D = $ButtonSound


func _on_button_bug_pressed() -> void:
	if not transitioning:
		button_sound.play()
		await button_sound.finished
		PlayerSelect.selected_player = "bug"
		transitioning = true
		await Transition.change_scene("res://scenes/level_1.tscn")


func _on_button_spider_pressed() -> void:
	if not transitioning:
		button_sound.play()
		await button_sound.finished
		PlayerSelect.selected_player = "spider"
		transitioning = true
		await Transition.change_scene("res://scenes/level_1.tscn")


func _on_button_beetle_pressed() -> void:
	if not transitioning:
		button_sound.play()
		await button_sound.finished
		PlayerSelect.selected_player = "beetle"
		transitioning = true
		await Transition.change_scene("res://scenes/level_1.tscn")


func _on_button_pill_pressed() -> void:
	if not transitioning:
		button_sound.play()
		PlayerSelect.selected_player = "pill"
		transitioning = true
		await button_sound.finished
		await Transition.change_scene("res://scenes/level_1.tscn")


func _on_button_pressed() -> void:
	if not transitioning:
		button_sound.play()
		await button_sound.finished
		transitioning = true
		await Transition.change_scene("res://scenes/basic_tutorial.tscn")
