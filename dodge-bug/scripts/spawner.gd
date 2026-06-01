extends Node2D

@export var player_prefab: PackedScene


func _on_timer_timeout() -> void:
	#spawn enemy
	var player = player_prefab.instantiate()
