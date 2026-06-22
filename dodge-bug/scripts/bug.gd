extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -800
const DASH_SPEED = 1500.0

const FALL_MULTIPLIER = 2.0

var dashing = false
var can_dash = true

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Gravity (better platformer feel)
	if not is_on_floor():
		if velocity.y < 0:
			# going up (normal gravity)
			velocity += get_gravity() * delta
		else:
			# falling (faster, snappier)
			velocity += get_gravity() * FALL_MULTIPLIER * delta
	else:
		# reset dash + movement state on floor
		can_dash = true

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Dash start
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Respawn
	if position.y > 1600:
		respawn()

func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
