extends Node2D

@export var projectile_scene: PackedScene
@export var shoot_interval := 15.0
@export var projectile_speed := 600

@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var nuzzle: Marker2D = $Nuzzle

var timer := 0.0

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var dir = player.global_position - global_position
	rotation = dir.angle()

	timer += delta

	if timer >= shoot_interval:
		timer = 0.0
		shoot(dir.normalized())


func shoot(dir: Vector2):
	var bullet = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# Spawn the bullet from the muzzle
	bullet.global_position = nuzzle.global_position
	bullet.direction = dir
	bullet.speed = projectile_speed

	if shoot_sound:
		shoot_sound.play()
