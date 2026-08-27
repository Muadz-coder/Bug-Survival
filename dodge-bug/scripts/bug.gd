extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -800
const DASH_SPEED = 1500.0
const UP_DASH_SPEED = 750
const FALL_MULTIPLIER = 2.0

var dashing = false
var can_dash = true
var dash_direction := Vector2.ZERO
var facing := 1
var dead := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var screech_sound: AudioStreamPlayer2D = $ScreechSound


func _ready():
	add_to_group("player")


func _physics_process(delta: float) -> void:

	if dead:
		return

	# Gravity
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta
	else:
		can_dash = true

	# --------------------------------
	# DASH
	# --------------------------------
	if Input.is_action_just_pressed("dash") and can_dash and not dashing:

		dashing = true
		can_dash = false

		# Q + Space while on floor = UPWARD DASH
		if Input.is_action_pressed("ui_accept") and is_on_floor():
			dash_direction = Vector2.UP
			velocity = Vector2(0, -UP_DASH_SPEED)

		# Q by itself = NORMAL DASH
		else:
			dash_direction = Vector2(facing, 0)
			velocity = Vector2(facing * DASH_SPEED, 0)

		$dash_timer.start()
		$dash_again_timer.start()

		if dash_sound:
			dash_sound.play()


	# --------------------------------
	# NORMAL JUMP
	# --------------------------------
	# Space by itself = jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not dashing:

		velocity.y = JUMP_VELOCITY

		if jump_sound:
			jump_sound.play()


	# --------------------------------
	# MOVEMENT
	# --------------------------------
	var direction := Input.get_axis("ui_left", "ui_right")

	if dashing:

		if dash_direction == Vector2.UP:
			velocity = Vector2(0, -UP_DASH_SPEED)
		else:
			velocity = Vector2(facing * DASH_SPEED, 0)

	else:

		if direction:
			facing = sign(direction)
			velocity.x = direction * SPEED
			sprite.flip_h = facing < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()

	update_animation()


	# Fall death
	if position.y > 1600:
		respawn()


func update_animation():

	if dashing:
		return

	if not is_on_floor():

		if sprite.animation != "jump":
			sprite.play("jump")

		return

	if abs(velocity.x) > 5:

		if sprite.animation != "walk":
			sprite.play("walk")

		return

	if sprite.animation != "idle":
		sprite.play("idle")


func respawn():
	
	if dead:
		return
	screech_sound.play()
	dead = true
	Global.timer_running = false
	velocity = Vector2.ZERO
	dashing = false

	await Transition.change_scene("res://scenes/died.tscn")


func _on_dash_timer_timeout() -> void:

	if not dead:
		dashing = false
		dash_direction = Vector2.ZERO


func _on_dash_again_timer_timeout() -> void:

	if not dead:
		can_dash = true
