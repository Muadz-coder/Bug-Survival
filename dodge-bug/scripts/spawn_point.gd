extends Node2D

@export var spike_scene: PackedScene
@export var warning_scene: PackedScene
@export var fruit_scene: PackedScene

@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_points2 = $SpawnPoints2.get_children()
@onready var spawn_point = $SpawnPoint
@onready var spike_timer = $SpawnTimer
@onready var warning_timer = $SpawnTimerW
@onready var fruit_timer = $SpawnTimerF

var pending_spike_positions: Array = []
var available_fruit_spawns: Array = []

func _ready():
	# Spawn selected player
	var player_scene_path = "res://prefabs/%s.tscn" % PlayerSelect.selected_player
	var player_scene = load(player_scene_path)
	var player = player_scene.instantiate()
	add_child(player)
	player.position = spawn_point.position
	Global.time_alive = 0
	Global.timer_running = true
	available_fruit_spawns = spawn_points2.duplicate()

func _process(delta):
	if Global.timer_running:
		Global.time_alive += delta

func get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]

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

func _on_spawn_timer_f_timeout() -> void:
	if available_fruit_spawns.is_empty():
		fruit_timer.stop()
		print("All fruit spawn points have been used.")
		return

	var index = randi() % available_fruit_spawns.size()
	var sp = available_fruit_spawns[index]

	# Remove this spawn point so it can't be used again
	available_fruit_spawns.remove_at(index)

	var fruit = fruit_scene.instantiate()
	fruit.global_position = sp.global_position
	add_child(fruit)

	if available_fruit_spawns.is_empty():
		fruit_timer.stop()
		print("All fruit spawn points have been used.")
