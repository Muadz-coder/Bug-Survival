extends Node2D

@export var rock_scene: PackedScene
@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_point = $SpawnPoint
@export var object_scene: PackedScene
@onready var spawn_timer = $SpawnTimer


func _ready():
	var player_scene_path = "res://prefabs/%s.tscn" % PlayerSelect.selected_player
	var player_scene = load(player_scene_path)
	var player = player_scene.instantiate()
	add_child(player)
	player.position = spawn_point.position


func get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]


func _on_SpawnTimer_timeout():
	for i in range(3):
		var rock = rock_scene.instantiate()
		var sp = get_random_spawn_point()
		rock.global_position = sp.global_position
		add_child(rock)
		delete_after_2_seconds(rock)


func delete_after_2_seconds(node):
	await get_tree().create_timer(2.0).timeout
	node.queue_free()
