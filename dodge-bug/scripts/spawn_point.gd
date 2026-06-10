extends Node2D

@export var pill_scene: PackedScene   
@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_point = $SpawnPoint
@onready var spawn_timer = $SpawnTimer


func _ready():
	# Spawn the selected player
	var player_scene_path = "res://prefabs/%s.tscn" % PlayerSelect.selected_player
	var player_scene = load(player_scene_path)
	var player = player_scene.instantiate()
	add_child(player)
	player.position = spawn_point.position


func get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]




func _on_spawn_timer_timeout() -> void:
	for i in range(3):
		var pill = pill_scene.instantiate()
		var sp = get_random_spawn_point()
		pill.global_position = sp.global_position
		add_child(pill)
