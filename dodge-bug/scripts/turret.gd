extends Area2D

@export var projectile_scene: PackedScene
@export var shoot_interval := 15.0
@export var projectile_speed := 600
@export var tracking_pause := 2.0

@export var shake_amount := 8.0
@export var shake_duration := 0.5

# Warning settings
@export var warning_time := 2.0
@export var flash_speed := 0.3

@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var nuzzle: Marker2D = $Nuzzle
@onready var sprite: Sprite2D = $Sprite2D # Change if your sprite has a different name

var timer := 0.0
var tracking_timer := 0.0
var shake_timer := 0.0
var locked_rotation := 0.0

var warning := false
var flash_timer := 0.0
var flash_on := false


func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	# Start warning before firing
	if !warning and timer >= shoot_interval - warning_time:
		warning = true

	# Flash brighter while warning
	if warning:
		flash_timer += delta
		if flash_timer >= flash_speed:
			flash_timer = 0.0
			flash_on = !flash_on

			if flash_on:
				sprite.modulate = Color(0.924, 0.0, 0.313, 1.0) # Bright white (Godot 4)
			else:
				sprite.modulate = Color.WHITE
	else:
		sprite.modulate = Color.WHITE

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

		# Stop warning
		warning = false
		flash_timer = 0.0
		flash_on = false
		sprite.modulate = Color.WHITE

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

		# Stop warning
		warning = false
		flash_timer = 0.0
		flash_on = false
		sprite.modulate = Color.RED

		# Stop tracking for 2 seconds
		tracking_timer = tracking_pause
		locked_rotation = rotation

		# Small vibration
		shake_timer = shake_duration
