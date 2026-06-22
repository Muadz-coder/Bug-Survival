extends CharacterBody2D

const SPEED = 350
const JUMP_VELOCITY = -800
const FALL_MULTIPLIER = 2.0

var is_invincible = false
var invincible_on_cooldown = false

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var invincible_sound: AudioStreamPlayer2D = $InvincibleSound
@onready var ready_sound: AudioStreamPlayer2D = $ReadySound

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:

	# Activate invincibility
	if Input.is_action_just_pressed("invincible") \
	and not is_invincible \
	and not invincible_on_cooldown:
		start_invincibility()

	# Gravity
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

		if jump_sound:
			jump_sound.play()

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Respawn
	if position.y > 1600:
		respawn()


func start_invincibility():
	is_invincible = true
	invincible_on_cooldown = true

	if invincible_sound:
		invincible_sound.play()

	await get_tree().create_timer(3.0).timeout

	is_invincible = false

	await get_tree().create_timer(5.0).timeout

	invincible_on_cooldown = false

	# READY sound when ability comes back
	if ready_sound:
		ready_sound.play()


func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
