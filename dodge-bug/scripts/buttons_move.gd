extends TextureButton

func _ready():
	# Connect signals to ourselves
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	# Scale up slightly when hovered
	create_tween().tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	modulate = Color(1.2, 1.2, 1.2) # Make it "glow" slightly

func _on_mouse_exited():
	# Return to normal size
	create_tween().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	modulate = Color(1.0, 1.0, 1.0, 1.0) # Reset color
