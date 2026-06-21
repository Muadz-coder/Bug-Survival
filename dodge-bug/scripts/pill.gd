extends CharacterBody2D

const SPEED = 350
const JUMP_VELOCITY = -800

var is_invincible = false
var invincible_on_cooldown = false

func _ready():
	add_to_group("player")
func _physics_process(delta: float) -> void:
	# Activate invincibility with R
	if Input.is_action_just_pressed("invincible") \
	and not is_invincible \
	and not invincible_on_cooldown:
		start_invincibility()

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Respawn if player falls
	if position.y > 1600:
		respawn()

func start_invincibility():
	is_invincible = true
	invincible_on_cooldown = true

	

	await get_tree().create_timer(3.0).timeout

	is_invincible = false
	

	await get_tree().create_timer(5.0).timeout

	invincible_on_cooldown = false
	

func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
