extends Label

@export var float_distance := 20.0
@export var float_speed := 2.0

var start_position: Vector2
var time := 0.0

func _ready():
	start_position = position

func _process(delta):
	time += delta * float_speed
	position.x = start_position.x + sin(time) * float_distance
