extends Area2D

signal collected(spawn_point)

var spawn_point

@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

func _ready():
	body_entered.connect(_on_body_entered)

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
