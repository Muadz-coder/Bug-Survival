extends Control

var transitioning: bool = false

func _process(delta):
	if Input.is_action_just_pressed("space_next") and not transitioning:
		transitioning = true
		get_tree().change_scene_to_file("res://scenes/bug_tutorial.tscn")
