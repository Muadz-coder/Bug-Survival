extends Node2D

@export var spike_scene: PackedScene
@export var warning_scene: PackedScene
@export var fruit_scene: PackedScene

@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_points2 = $SpawnPoints2.get_children()
@onready var spawn_point = $SpawnPoint
@onready var spike_timer = $SpawnTimer
@onready var warning_timer = $SpawnTimerW


var pending_spike_positions: Array = []

func _ready():
	# Spawn selected player
	var player_scene_path = "res://prefabs/%s.tscn" % PlayerSelect.selected_player
	var player_scene = load(player_scene_path)
	var player = player_scene.instantiate()
	add_child(player)
	player.position = spawn_point.position


func get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]

func get_random_spawn_points2():
	return spawn_points2[randi() % spawn_points2.size()]

func _on_spawn_timer_w_timeout() -> void:
	pending_spike_positions.clear()

	for i in range(5):
		var sp = get_random_spawn_point()
		pending_spike_positions.append(sp.global_position)

		var warning = warning_scene.instantiate()
		warning.global_position = sp.global_position
		add_child(warning)

	await get_tree().create_timer(1.0).timeout

	for pos in pending_spike_positions:
		var spike = spike_scene.instantiate()
		spike.global_position = pos
		add_child(spike)



var occupied_points := {}

func _on_spawn_timer_f_timeout() -> void:
	var available := []

	# Collect all spawn points that are NOT occupied
	for sp in spawn_points2:
		if not occupied_points.has(sp):
			available.append(sp)

	# If no free points, stop
	if available.is_empty():
		return

	# Spawn up to 3 fruits on free points
	for i in range(min(3, available.size())):
		var sp = available.pick_random()
		available.erase(sp)

		var fruit = fruit_scene.instantiate()
		fruit.global_position = sp.global_position
		add_child(fruit)

		# Mark spawn point as occupied
		occupied_points[sp] = fruit

		# Free the point when fruit disappears
		fruit.tree_exited.connect(func():
			occupied_points.erase(sp))
