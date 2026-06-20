extends Panel

@export var drift_amount: float = 2.0
@export var drift_speed: float = 0.5

var base_position: Vector2
var target_offset: Vector2 = Vector2.ZERO
var current_offset: Vector2 = Vector2.ZERO
var timer: float = 0.0

func _ready():
	base_position = position
	_pick_new_target()

func _process(delta):
	timer += delta * drift_speed

	current_offset = current_offset.lerp(target_offset, 0.02)
	position = base_position + current_offset

	if timer > 2.0:
		timer = 0.0
		_pick_new_target()

func _pick_new_target():
	var amount = drift_amount if drift_amount != null else 2.0
	
	target_offset = Vector2(
		randf_range(-amount, amount),
		randf_range(-amount, amount)
	)
