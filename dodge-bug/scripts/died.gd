extends Control

@onready var label: RichTextLabel = $Label
@onready var time_label: RichTextLabel = $TimeLabel

@onready var panel_label: Panel = $PanelLabel
@onready var panel_time_label: Panel = $PanelTimeLabel

@onready var button_sound: AudioStreamPlayer2D = $ButtonSound
@onready var lost_label: Label = $Lost

@onready var restart_button: Button = $RestartButton
@onready var menu_button: Button = $MenuButton

var use_red := true


func _ready():
	# =========================
	# FORCE DRAW ORDER
	# =========================

	# Panels behind text
	panel_label.z_index = 0
	panel_time_label.z_index = 0

	# Text above panels
	label.z_index = 10
	time_label.z_index = 10


	# =========================
	# SET TEXT
	# =========================

	label.text = "[color=#211f30]Fruits collected:[/color]\n[color=#AEEBFF]%s[/color]" % str(Global.points)

	var rounded_time: float = round(Global.time_alive * 10.0) / 10.0

	time_label.text = "[color=#211f30]Time survived(s):[/color]\n[color=#AEEBFF]%.1f s[/color]" % rounded_time


	# =========================
	# HIDE PANELS
	# =========================

	panel_label.hide()
	panel_time_label.hide()


	# =========================
	# HIDE TEXT
	# =========================

	label.hide()
	time_label.hide()


	# =========================
	# HIDE BUTTONS
	# =========================

	restart_button.hide()
	menu_button.hide()


	# =========================
	# FLASHING LOST LABEL
	# =========================

	var flash_timer := Timer.new()
	flash_timer.wait_time = 0.5
	flash_timer.autostart = true

	add_child(flash_timer)
	flash_timer.timeout.connect(_on_flash_timer)


	# =========================
	# SHOW UI AFTER DELAY
	# =========================

	var show_timer := Timer.new()
	show_timer.wait_time = 2.5
	show_timer.one_shot = true
	show_timer.autostart = true

	add_child(show_timer)
	show_timer.timeout.connect(_on_show_buttons)


func _on_show_buttons():
	# =========================
	# HIDE LOST
	# =========================

	lost_label.hide()


	# =========================
	# SHOW BUTTONS
	# =========================

	restart_button.show()
	menu_button.show()


	# =========================
	# SHOW PANELS
	# =========================

	panel_label.show()
	panel_time_label.show()


	# =========================
	# SHOW TEXT
	# =========================

	label.show()
	time_label.show()


	var tween := create_tween()


	# =========================
	# START SMALL + TRANSPARENT
	# =========================

	restart_button.scale = Vector2(0.6, 0.6)
	menu_button.scale = Vector2(0.6, 0.6)

	panel_label.scale = Vector2(0.6, 0.6)
	panel_time_label.scale = Vector2(0.6, 0.6)

	label.scale = Vector2(0.6, 0.6)
	time_label.scale = Vector2(0.6, 0.6)

	restart_button.modulate.a = 0.0
	menu_button.modulate.a = 0.0

	panel_label.modulate.a = 0.0
	panel_time_label.modulate.a = 0.0

	label.modulate.a = 0.0
	time_label.modulate.a = 0.0


	# =========================
	# BUTTONS POP IN FIRST
	# =========================

	tween.tween_property(
		restart_button,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		menu_button,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


	# Button fade in
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
		Color.WHITE,
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		menu_button,
		"modulate",
		Color.WHITE,
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


	# =========================
	# SMALL PAUSE
	# =========================

	tween.tween_interval(0.15)


	# =========================
	# PANELS + TEXT POP TOGETHER
	# =========================

	tween.tween_property(
		panel_label,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		panel_time_label,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		label,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		time_label,
		"scale",
		Vector2.ONE,
		0.28
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


	# =========================
	# PANELS + TEXT FADE IN
	# =========================

	tween.parallel().tween_property(
		panel_label,
		"modulate:a",
		1.0,
		0.25
	)

	tween.parallel().tween_property(
		panel_time_label,
		"modulate:a",
		1.0,
		0.25
	)

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


	# =========================
	# PANEL + TEXT GLOW
	# =========================

	tween.parallel().tween_property(
		panel_label,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		panel_time_label,
		"modulate",
		Color(1.3, 1.3, 1.3, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

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


	# =========================
	# RETURN TO NORMAL
	# =========================

	tween.parallel().tween_property(
		panel_label,
		"modulate",
		Color.WHITE,
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		panel_time_label,
		"modulate",
		Color.WHITE,
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		label,
		"modulate",
		Color.WHITE,
		0.22
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		time_label,
		"modulate",
		Color.WHITE,
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
