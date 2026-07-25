extends CharacterBody2D

const SPEED = 400
const JUMP_VELOCITY = -800
const FALL_MULTIPLIER = 2.0

# Charged Jump
const CHARGE_TIME = 0.25
const SUPER_JUMP_MULTIPLIER = 1.55

var is_charging = false
var charge_timer = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

@onready var idle_collision = $IdleCollision
@onready var walk_collision = $WalkingCollision
@onready var jump_collision = $JumpCollision


func _ready():
	add_to_group("player")


func _physics_process(delta: float) -> void:

	# Gravity
	if !is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta


	# Start charging when jump is pressed
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		is_charging = true
		charge_timer = 0.0
		velocity.x = 0

		if sprite.animation != "charge":
			sprite.play("charge")

	# Continue charging
	if is_charging:
		velocity.x = 0
		charge_timer += delta

		# Release to jump
		if Input.is_action_just_released("ui_accept"):

			if charge_timer >= CHARGE_TIME:
				velocity.y = JUMP_VELOCITY * SUPER_JUMP_MULTIPLIER
			else:
				velocity.y = JUMP_VELOCITY

			if jump_sound:
				jump_sound.play()

			is_charging = false
			charge_timer = 0.0

	# -----------------------------
	# Horizontal Movement
	# -----------------------------
	if !is_charging:
		var direction := Input.get_axis("ui_left", "ui_right")

		if direction != 0:
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animation()
	update_hitbox()

	# Fall death
	if position.y > 1600:
		respawn()


func update_animation():

	# Charge animation has highest priority
	if is_charging:
		if sprite.animation != "charge":
			sprite.play("charge")
		return

	# Jump animation
	if !is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
		return

	# Walk animation
	if abs(velocity.x) > 5:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")


func update_hitbox():

	idle_collision.disabled = true
	walk_collision.disabled = true
	jump_collision.disabled = true

	if !is_on_floor():
		jump_collision.disabled = false
	elif abs(velocity.x) > 5:
		walk_collision.disabled = false
	else:
		idle_collision.disabled = false


func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
