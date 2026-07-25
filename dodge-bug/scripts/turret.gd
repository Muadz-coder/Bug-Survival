extends Area2D

@export var projectile_scene: PackedScene
@export var shoot_interval := 15.0
@export var projectile_speed := 600
@export var tracking_pause := 2.0

@export var shake_amount := 8.0
@export var shake_duration := 0.5

@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var nuzzle: Marker2D = $Nuzzle

var timer := 0.0
var tracking_timer := 0.0
var shake_timer := 0.0
var locked_rotation := 0.0


func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	# Shake when player touches turret
	if shake_timer > 0:
		shake_timer -= delta
		rotation = locked_rotation + deg_to_rad(randf_range(-shake_amount, shake_amount))
		return

	# Track player unless paused
	if tracking_timer <= 0:
		var dir = player.global_position - global_position
		locked_rotation = dir.angle()
		rotation = locked_rotation
	else:
		tracking_timer -= delta
		rotation = locked_rotation

	timer += delta

	if timer >= shoot_interval:
		timer = 0.0

		var dir = (player.global_position - global_position).normalized()
		shoot(dir)

		# Stop tracking after shooting
		locked_rotation = rotation
		tracking_timer = tracking_pause


func shoot(dir: Vector2):
	var bullet = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = nuzzle.global_position
	bullet.direction = dir
	bullet.speed = projectile_speed

	if shoot_sound:
		shoot_sound.play()


func _on_body_entered(body):
	if body.is_in_group("player"):
		# Restart shooting cooldown
		timer = 0.0

		# Stop tracking for 2 seconds
		tracking_timer = tracking_pause
		locked_rotation = rotation

		# Small vibration
		shake_timer = shake_duration
