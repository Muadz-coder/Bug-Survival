extends Area2D

signal collected(spawn_point)

var spawn_point
var is_collected := false

@onready var collect_sound: AudioStreamPlayer2D = $CollectSound
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var time := randf() * TAU
var start_y := 0.0

@export var bob_height := 5.0
@export var bob_speed := 2.5

func _ready():
	start_y = position.y
	body_entered.connect(_on_body_entered)

	# Play idle animation
	animated_sprite.play("idle")


func _process(delta):
	time += delta
	position.y = start_y + sin(time * bob_speed) * bob_height


func _on_body_entered(body):
	if is_collected:
		return

	if !body.has_method("respawn"):
		return

	is_collected = true

	# Disable any future collisions
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	collision_shape.set_deferred("disabled", true)

	# Stop floating
	set_process(false)

	# Give the player a point
	Global.points += 1

	# Tell the spawner this spot is free
	collected.emit(spawn_point)

	# Play effects
	animated_sprite.play("collected")
	collect_sound.play()

	# Wait until the animation finishes
	await animated_sprite.animation_finished

	queue_free()
