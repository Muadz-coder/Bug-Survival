extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -750
const ZIPLINE_SPEED = 750
const STOP_DISTANCE = 25
@onready var web_line: Line2D = $WebLine
var grappling := false
var grapple_point := Vector2.ZERO
func _ready():
	add_to_group("player")
# 🕸️ NEW: air web limit
var web_air_count := 0
const MAX_AIR_WEBS := 2

func update_web_line():
	if grappling:
		web_line.visible = true
		web_line.clear_points()

		var start = web_line.to_local(global_position)
		var end = web_line.to_local(grapple_point)

		web_line.add_point(start)
		web_line.add_point(end)
	else:
		web_line.visible = false
func _physics_process(delta):

	# 🌍 GRAVITY ALWAYS
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# 🧠 reset webs when touching ground
		web_air_count = 0
	update_web_line()


	# 🎮 MOVEMENT (only when not grappling)
	if not grappling:
		var input_dir := Input.get_axis("ui_left", "ui_right")

		if input_dir != 0:
			velocity.x = input_dir * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY


	# 🕸️ GRAPPLE MODE
	if grappling:
		var dir := grapple_point - global_position

		velocity = dir.normalized() * ZIPLINE_SPEED

		# stop when close
		if dir.length() < STOP_DISTANCE:
			grappling = false
			velocity *= 0.3

		# stop on any StaticBody2D collision
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)

			if collision and collision.get_collider() is StaticBody2D:
				grappling = false
				velocity = Vector2.ZERO
				break


	# 🕸️ SHOOT GRAPPLE (LIMITED IN AIR)
	if Input.is_action_just_pressed("grapple") and not grappling:

		if not is_on_floor():
			if web_air_count >= MAX_AIR_WEBS:
				return
			web_air_count += 1

		shoot_grapple()


	move_and_slide()


	# ☠️ FALL RESET
	if position.y > 1600:
		respawn()


# 🧷 RAYCAST GRAPPLE
func shoot_grapple():
	var space := get_world_2d().direct_space_state

	var from := global_position
	var to := get_global_mouse_position()

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result := space.intersect_ray(query)

	if result:
		grappling = true
		grapple_point = result.position + result.normal * 8


func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
