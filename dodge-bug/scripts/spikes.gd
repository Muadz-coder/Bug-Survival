extends Area2D

@onready var life_timer = $LifeTimer

func _ready():
	life_timer.timeout.connect(_on_life_timer_timeout)

func _on_life_timer_timeout():
	queue_free()
