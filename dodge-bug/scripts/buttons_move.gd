extends TextureButton

@export var float_amount := 10.0

var base_position: Vector2

func _ready():
	base_position = global_position

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	create_tween().tween_property(self, "scale", Vector2(1.05, 1.05), 0.08)
	modulate = Color(1.15, 1.15, 1.15)

func _on_mouse_exited():
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.08)
	modulate = Color(1, 1, 1, 1)
