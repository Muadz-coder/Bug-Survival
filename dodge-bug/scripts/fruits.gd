extends Area2D

signal collected(spawn_point)

var spawn_point

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("respawn"):
		Global.points += 1

		# Tell the spawner this spot is free again
		collected.emit(spawn_point)

		queue_free()
