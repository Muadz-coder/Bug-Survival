
extends Control

@onready var label: RichTextLabel = $Label
@onready var time_label: RichTextLabel = $TimeLabel
@onready var button_sound: AudioStreamPlayer2D = $ButtonSound
@onready var lost_label: Label = $Lost

@onready var restart_button: Button = $RestartButton
@onready var menu_button: Button = $MenuButton

var use_red := true


func _ready():
	# Fruits collected
	label.text = "[color=#419fd6]Fruits collected:[/color]\n\n[color=#AEEBFF]%s[/color]" % str(Global.points)

	# Time survived (1 decimal)
	var rounded_time: float = round(Global.time_alive * 10.0) / 10.0
	time_label.text = "[color=#419fd6]Time survived(s):[/color]\n\n[color=#AEEBFF]%.1f s[/color]" % rounded_time

	# Hide labels initially
	label.hide()
	time_label.hide()

	# Hide buttons initially
	restart_button.hide()
	menu_button.hide()

	# Flashing LOST label
	var flash_timer := Timer.new()
	flash_timer.wait_time = 0.5
	flash_timer.autostart = true
	add_child(flash_timer)
	flash_timer.timeout.connect(_on_flash_timer)

	# Show buttons after delay
	var show_timer := Timer.new()
	show_timer.wait_time = 2.5
	show_timer.one_shot = true
	show_timer.autostart = true
	add_child(show_timer)
	show_timer.timeout.connect(_on_show_buttons)


func _on_show_buttons():
	# Hide LOST label
	lost_label.hide()

	# Show buttons and labels
	restart_button.show()
	menu_button.show()
	label.show()
	time_label.show()

	var tween := create_tween()

	# =========================
	# START SMALL + TRANSPARENT
	# =========================

	restart_button.scale = Vector2(0.6, 0.6)
	menu_button.scale = Vector2(0.6, 0.6)

	label.scale = Vector2(0.6, 0.6)
	time_label.scale = Vector2(0.6, 0.6)

	restart_button.modulate.a = 0.0
	menu_button.modulate.a = 0.0

	label.modulate.a = 0.0
	time_label.modulate.a = 0.0

	# =========================
	# BUTTONS POP IN FIRST
	# =========================

	tween.tween_property(
		restart_button,
		"scale",
		Vector2(1, 1),
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		menu_button,
		"scale",
		Vector2(1, 1),
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Button fade-in
	tween.parallel().tween_property(
		restart_button,
		"modulate:a",
		1.0,
		0.25
	)

	tween.parallel().tween_property(
		menu_button,
		"modulate:a",
		1.0,
		0.25
	)

	# Button glow
	tween.parallel().tween_property(
		restart_button,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		menu_button,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Return buttons to normal
	tween.parallel().tween_property(
		restart_button,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		menu_button,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# =========================
	# SMALL PAUSE
	# =========================

	tween.tween_interval(0.15)

	# =========================
	# LABELS POP IN AFTER BUTTONS
	# =========================

	tween.tween_property(
		label,
		"scale",
		Vector2(1, 1),
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		time_label,
		"scale",
		Vector2(1, 1),
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Label fade-in
	tween.parallel().tween_property(
		label,
		"modulate:a",
		1.0,
		0.25
	)

	tween.parallel().tween_property(
		time_label,
		"modulate:a",
		1.0,
		0.25
	)

	# Label glow
	tween.parallel().tween_property(
		label,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		time_label,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Return labels to normal
	tween.parallel().tween_property(
		label,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		time_label,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _on_flash_timer():
	lost_label.modulate = Color.RED if use_red else Color.WHITE
	use_red = !use_red


func _on_restart_button_pressed():
	button_sound.play()
	Global.points = 0

	await button_sound.finished
	await Transition.change_scene("res://scenes/level_1.tscn")


func _on_menu_button_pressed():
	button_sound.play()
	Global.points = 0

	await button_sound.finished
	await Transition.change_scene("res://scenes/menu.tscn")
