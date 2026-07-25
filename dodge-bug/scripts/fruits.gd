extends Area2D

signal collected(spawn_point)

var spawn_point

@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

var time := randf() * TAU
var start_y := 0.0

@export var bob_height := 5.0   # Pixels up/down
@export var bob_speed := 2.5    # Speed of bobbing

func _ready():
	start_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta):
	time += delta
	position.y = start_y + sin(time * bob_speed) * bob_height

func _on_body_entered(body):
	if body.has_method("respawn"):
		Global.points += 1

		# Play sound effect
		collect_sound.play()

		# Tell the spawner this spot is free again
		collected.emit(spawn_point)

		# Wait a tiny bit so the sound can play before deleting
		await get_tree().create_timer(0.1).timeout
		queue_free()
