extends CharacterBody2D

const SPEED = 400
const JUMP_VELOCITY = -800
const FALL_MULTIPLIER = 2.0

var is_invincible = false
var invincible_on_cooldown = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var invincible_sound: AudioStreamPlayer2D = $InvincibleSound
@onready var ready_sound: AudioStreamPlayer2D = $ReadySound

@onready var normal_collision: CollisionShape2D = $CollisionShape2D
@onready var roll_collision: CollisionShape2D = $RollCollision

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("invincible") \
	and not is_invincible \
	and not invincible_on_cooldown:
		start_invincibility()

	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if jump_sound:
			jump_sound.play()

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animation()
	update_collisions()

	if position.y > 1600:
		respawn()

func update_animation():
	if is_invincible:
		if sprite.animation != "roll":
			sprite.play("roll")
		return

	if !is_on_floor() or abs(velocity.x) > 5:
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

	if invincible_sound:
		invincible_sound.play()

	await get_tree().create_timer(3.0).timeout
	is_invincible = false

	await get_tree().create_timer(5.0).timeout
	invincible_on_cooldown = false

	if ready_sound:
		ready_sound.play()

func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
