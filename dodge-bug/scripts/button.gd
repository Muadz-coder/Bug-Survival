extends Button

@export var strength := 6.0      # how far it can drift
@export var smoothness := 4.0    # higher = smoother/slower changes

var base_position: Vector2
var velocity := Vector2.ZERO

func _ready():
	base_position = position

func _process(delta):
	# pick a tiny random direction influence every frame
	var random_force = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)

	velocity = velocity.lerp(random_force * strength, delta * smoothness)

	position = base_position + velocity
