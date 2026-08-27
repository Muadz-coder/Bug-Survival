extends CharacterBody2D

const SPEED = 400
const JUMP_VELOCITY = -800
const FALL_MULTIPLIER = 2.0

const READY_FLASH_DURATION = 2.0
const FLASH_SPEED = 0.25

var is_invincible = false
var invincible_on_cooldown = false
var dead := false

var ready_flash := false
var flash_on := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var invincible_sound: AudioStreamPlayer2D = $InvincibleSound
@onready var screech_sound: AudioStreamPlayer2D = $ScreechSound

@onready var normal_collision: CollisionShape2D = $CollisionShape2D
@onready var roll_collision: CollisionShape2D = $RollCollision


func _ready():
	add_to_group("player")


func _physics_process(delta: float) -> void:

	# Stop input and movement during transition
	if dead:
		return


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

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()

	update_animation()
	update_collisions()


	# Fall death
	if position.y > 1600:
		respawn()



func update_animation():

	# Prevent animation from overriding flash
	if ready_flash:
		return


	if is_invincible:
		if sprite.animation != "roll":
			sprite.play("roll")
		return


	if not is_on_floor():
		if sprite.animation != "walk":
			sprite.play("walk")

	elif abs(velocity.x) > 5:
		if sprite.animation != "walk":
			sprite.play("walk")

	else:
		if sprite.animation != "idle":
			sprite.play("idle")



func update_collisions():

	if is_invincible:
		normal_collision.disabled = true
		roll_collision.disabled = false

	else:
		normal_collision.disabled = false
		roll_collision.disabled = true



func start_invincibility():

	is_invincible = true
	invincible_on_cooldown = true

	# Stop any ready flash when invincibility is activated
	ready_flash = false
	flash_on = false
	sprite.modulate = Color.WHITE

	if invincible_sound:
		invincible_sound.play()


	# Invincibility lasts 3 seconds
	await get_tree().create_timer(3.0).timeout

	if dead:
		return

	is_invincible = false


	# Cooldown lasts another 5 seconds
	await get_tree().create_timer(5.0).timeout

	if dead:
		return

	invincible_on_cooldown = false

	# Start the ready flash
	start_ready_flash()



func start_ready_flash():

	ready_flash = true

	var timer := 0.0

	while timer < READY_FLASH_DURATION:

		if dead:
			return

		await get_tree().create_timer(FLASH_SPEED).timeout

		timer += FLASH_SPEED

		flash_on = !flash_on

		if flash_on:
			sprite.modulate = Color(1.5, 1.5, 1.5)
		else:
			sprite.modulate = Color.WHITE


	# Make sure the sprite returns to normal
	sprite.modulate = Color.WHITE
	flash_on = false
	ready_flash = false



func respawn():

	if dead:
		return
	
	screech_sound.play()
	dead = true

	Global.timer_running = false

	velocity = Vector2.ZERO
	is_invincible = false

	# Reset flash
	ready_flash = false
	flash_on = false
	sprite.modulate = Color.WHITE

	await Transition.change_scene("res://scenes/died.tscn")
