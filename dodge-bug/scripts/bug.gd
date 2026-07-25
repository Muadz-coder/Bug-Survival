extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -800
const DASH_SPEED = 1500.0
const FALL_MULTIPLIER = 2.0

var dashing = false
var can_dash = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound


func _ready():
	add_to_group("player")


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta
	else:
		# Reset dash when on ground
		can_dash = true

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

		if jump_sound:
			jump_sound.play()

	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false

		$dash_timer.start()
		$dash_again_timer.start()

		if dash_sound:
			dash_sound.play()

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED

		sprite.flip_h = direction < 0

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animation()

	# Fall death
	if position.y > 1600:
		respawn()


func update_animation():

	# Jump animation
	if not is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
		return

	# Walk animation
	if abs(velocity.x) > 5:
		if sprite.animation != "walk":
			sprite.play("walk")
		return

	# Idle animation
	if sprite.animation != "idle":
		sprite.play("idle")


func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_again_timer_timeout() -> void:
	can_dash = true
