extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -750
const ZIPLINE_SPEED = 750
const STOP_DISTANCE = 25
const FALL_MULTIPLIER = 2.0

@onready var collision_walking: CollisionShape2D = $CollisionWalking
@onready var shoot_collision: Marker2D = $ShootCollision
@onready var down_collision: Marker2D = $DownCollision
@onready var web_line: Line2D = $WebLine
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var grapple_sound: AudioStreamPlayer2D = $GrappleSound
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var grappling := false
var grapple_point := Vector2.ZERO

var web_air_count := 0
const MAX_AIR_WEBS := 2

var floor_buffer := 0.0
const FLOOR_REMEMBER_TIME := 0.10

var last_facing := 1


func _ready():
	add_to_group("player")
	collision_walking.disabled = false
	animation.play("walk")


func update_floor_buffer(delta):
	if is_on_floor():
		floor_buffer = FLOOR_REMEMBER_TIME
	else:
		floor_buffer = max(floor_buffer - delta, 0)


func get_grapple_origin() -> Vector2:
	if get_global_mouse_position().y > global_position.y:
		return down_collision.global_position
	else:
		return shoot_collision.global_position


func update_web_line():
	if grappling:
		web_line.visible = true
		web_line.clear_points()

		var start = web_line.to_local(get_grapple_origin())
		var end = web_line.to_local(grapple_point)

		web_line.add_point(start)
		web_line.add_point(end)
	else:
		web_line.visible = false


func update_animation(input_dir: float):
	if input_dir != 0:
		last_facing = sign(input_dir)
		animation.flip_h = input_dir < 0
	else:
		animation.flip_h = last_facing < 0

	if grappling:
		if animation.animation != "jump":
			animation.play("jump")
	else:
		if animation.animation != "walk":
			animation.play("walk")


func _physics_process(delta):

	# GRAVITY
	if floor_buffer <= 0:
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta
	else:
		web_air_count = 0

	# WEB LINE
	update_web_line()

	var input_dir := Input.get_axis("ui_left", "ui_right")

	# MOVEMENT
	if not grappling:
		if input_dir != 0:
			velocity.x = input_dir * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("ui_accept") and floor_buffer > 0:
			velocity.y = JUMP_VELOCITY

			if jump_sound:
				jump_sound.play()

	# GRAPPLING
	if grappling:
		var dir := grapple_point - global_position
		var dist := dir.length()

		velocity = dir.normalized() * ZIPLINE_SPEED

		if dist < STOP_DISTANCE:
			grappling = false
			velocity *= 0.3

		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision and collision.get_collider() is StaticBody2D:
				grappling = false
				break

	# GRAPPLE INPUT
	if Input.is_action_just_pressed("grapple"):

		if grappling:
			grappling = false
			velocity *= 0.5

		else:
			if floor_buffer <= 0:
				if web_air_count >= MAX_AIR_WEBS:
					return
				web_air_count += 1

			shoot_grapple()

	# ANIMATION
	update_animation(input_dir)

	# APPLY MOVEMENT
	move_and_slide()

	# FLOOR BUFFER
	update_floor_buffer(delta)

	# DEATH ZONE
	if position.y > 1600:
		respawn()


func shoot_grapple():
	var space := get_world_2d().direct_space_state

	var from := get_grapple_origin()
	var to := get_global_mouse_position()

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result := space.intersect_ray(query)

	if result:
		grappling = true
		grapple_point = result.position + result.normal * 8

		animation.play("jump")

		if grapple_sound:
			grapple_sound.play()


func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
