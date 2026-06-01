extends Node2D

@onready var player_scene = preload("res://prefabs/beetle.tscn")

func spawn_player():
	var player = player_scene.instantiate()
	player.position = position
	get_tree().current_scene.add_child(player)
