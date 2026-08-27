extends Control

var transitioning := false






func _input(event):
	if event.is_action_pressed("space_next") and not transitioning:
		transitioning = true
		_start_delay()


func _start_delay():
	var timer := Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_do_transition)
	timer.start()


func _do_transition():
	Transition.change_scene("res://scenes/bug_tutorial.tscn")
