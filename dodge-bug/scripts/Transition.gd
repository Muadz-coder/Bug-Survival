extends CanvasLayer

const FADE_TIME := 0.8

var transitioning := false

@onready var rect: ColorRect = $ColorRect


func _ready():
	# Start invisible
	rect.self_modulate.a = 0
	
	# Allow buttons behind it to work
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE



func change_scene(scene_path: String):

	# Prevent double transitions
	if transitioning:
		return

	transitioning = true


	# Fade to black
	var fade_out = create_tween()
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.tween_property(
		rect,
		"self_modulate:a",
		1.0,
		FADE_TIME
	)

	await fade_out.finished


	# Change scene
	get_tree().change_scene_to_file(scene_path)

	# Wait for new scene to load
	await get_tree().process_frame


	# Fade back in
	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_property(
		rect,
		"self_modulate:a",
		0.0,
		FADE_TIME
	)

	await fade_in.finished


	transitioning = false
