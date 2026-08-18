extends Button

@export var strength := 6.0      # how far it can drift
@export var smoothness := 4.0    # higher = smoother/slower changes
@export var hover_scale := 1.08  # scale when hovered
@export var hover_glow := 1.25   # brightness when hovered
@export var hover_speed := 0.12  # tween speed

var base_position: Vector2
var velocity := Vector2.ZERO
var hovered := false

func _ready():
	base_position = position

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _process(delta):
	# pick a tiny random direction influence every frame
	var random_force = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)

	velocity = velocity.lerp(random_force * strength, delta * smoothness)
	position = base_position + velocity


func _on_mouse_entered():
	hovered = true
	var tween := create_tween()

	# scale pop
	tween.tween_property(self, "scale", Vector2(hover_scale, hover_scale), hover_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# glow (brighten)
	tween.parallel().tween_property(self, "modulate", Color(hover_glow, hover_glow, hover_glow), hover_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	hovered = false
	var tween := create_tween()

	# scale back to normal
	tween.tween_property(self, "scale", Vector2.ONE, hover_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# remove glow
	tween.parallel().tween_property(self, "modulate", Color(1, 1, 1), hover_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
