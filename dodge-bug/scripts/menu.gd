extends Control

var transitioning: bool = false

func _on_button_bug_pressed() -> void:
	if not transitioning:
		PlayerSelect.selected_player = "bug"
		transitioning = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_button_spider_pressed() -> void:
	if not transitioning:
		PlayerSelect.selected_player = "spider"
		transitioning = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_button_beetle_pressed() -> void:
	if not transitioning:
		PlayerSelect.selected_player = "beetle"
		transitioning = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_button_pill_pressed() -> void:
	if not transitioning:
		PlayerSelect.selected_player = "pill"
		transitioning = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
