extends HBoxContainer

@export var float_amount := 12.0
@export var float_speed := 3.0

var base_position: Vector2
var time := 0.0

func _ready():
	base_position = global_position

func _process(delta):
	time += delta * float_speed
	global_position.x = base_position.x + sin(time) * float_amount
