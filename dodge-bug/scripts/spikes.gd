extends Area2D

@onready var life_timer = $LifeTimer
@onready var animated_sprite = $AnimatedSprite2D

var time := randf() * TAU
var start_x := 0.0

@export var move_distance := 6.0
@export var move_speed := 2.5

func _ready():
	start_x = position.x

	animated_sprite.play("idle")

	life_timer.timeout.connect(_on_life_timer_timeout)
	body_entered.connect(_on_body_entered)

func _process(delta):
	time += delta
	position.x = start_x + sin(time * move_speed) * move_distance

func _on_life_timer_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("respawn"):
		if body.get("is_invincible"):
			return

		body.respawn()
