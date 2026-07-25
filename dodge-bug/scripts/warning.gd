extends Area2D

@onready var life_timer = $LifeTimer

var start_position: Vector2
var time := 0.0

# Adjust these to taste
@export var bob_height := 12.0
@export var bob_speed := 4.0


func _ready():
	start_position = position
	life_timer.timeout.connect(_on_life_timer_timeout)

func _process(delta):
	time += delta
	position.y = start_position.y + sin(time * bob_speed) * bob_height

func _on_life_timer_timeout():
	queue_free()
