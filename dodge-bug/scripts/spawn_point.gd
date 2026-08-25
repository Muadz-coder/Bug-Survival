extends Node2D

@export var spike_scene: PackedScene
@export var warning_scene: PackedScene
@export var fruit_scenes: Array[PackedScene]

@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_points2 = $SpawnPoints2.get_children()
@onready var spawn_point = $SpawnPoint
@onready var spike_timer = $SpawnTimer
@onready var warning_timer = $SpawnTimerW
@onready var fruit_timer = $SpawnTimerF
@onready var music: AudioStreamPlayer2D = $Music
@onready var danger_sound : AudioStreamPlayer2D = $DangerSound

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

	# All fruit spawn points start available
	available_fruit_spawns = spawn_points2.duplicate()

	# Start music
	music.play()


func _process(delta):
	if Global.timer_running:
		Global.time_alive += delta


func _exit_tree():
	# Stop music when this scene is changed/removed
	if music:
		music.stop()


func get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]


func _on_spawn_timer_w_timeout() -> void:
	pending_spike_positions.clear()

	for i in range(5):

		var sp = get_random_spawn_point()
		

		if pending_spike_positions.has(sp.global_position):
			continue

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
	# No free spots left
	if available_fruit_spawns.is_empty():
		return

	# Pick a free spawn point
	var index = randi() % available_fruit_spawns.size()
	var sp = available_fruit_spawns[index]

	# Mark this spot as occupied
	available_fruit_spawns.remove_at(index)

	# Pick a random fruit scene
	var random_fruit_scene = fruit_scenes[randi() % fruit_scenes.size()]
	var fruit = random_fruit_scene.instantiate()

	fruit.global_position = sp.global_position
	fruit.spawn_point = sp

	# Listen for collection
	fruit.collected.connect(_on_fruit_collected)

	add_child(fruit)


func _on_fruit_collected(spawn_point):
	if not available_fruit_spawns.has(spawn_point):
		available_fruit_spawns.append(spawn_point)
