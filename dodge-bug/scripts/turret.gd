extends Node2D

@export var projectile_scene: PackedScene
@export var shoot_interval := 15.0
@export var projectile_speed := 600

var player: Node2D = null
var timer := 0.0


func _process(delta):
	# find player if not ready yet
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return

	# 🎯 rotate turret to face player
	look_at(player.global_position)

	timer += delta

	if timer >= shoot_interval:
		timer = 0
		shoot()


func shoot():
	var bullet = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = global_position

	# 🔥 shoot in turret's facing direction
	var dir = Vector2.RIGHT.rotated(rotation)

	bullet.direction = dir
	bullet.speed = projectile_speed
