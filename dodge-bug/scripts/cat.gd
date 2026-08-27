extends CharacterBody2D

const SPEED = 400
const JUMP_VELOCITY = -800
const FALL_MULTIPLIER = 2.0

const PARRY_DURATION = 0.5
const PARRY_STARTUP = 0.05
const PARRY_COOLDOWN = 5

const READY_FLASH_DURATION = 2
const FLASH_SPEED = 0.25


var is_parrying := false
var can_parry := true
var dead := false

var ready_flash := false
var flash_on := false

@onready var screech_sound: AudioStreamPlayer2D = $ScreechSound
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var parry_area: Area2D = $ParryArea
@onready var invicible_sound: AudioStreamPlayer2D = $InvincibleSound



func _ready():
	add_to_group("player")
	parry_area.monitoring = false



func _physics_process(delta):

	if dead:
		return


	# Gravity
	if !is_on_floor():

		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * FALL_MULTIPLIER * delta



	# Start parry
	if Input.is_action_just_pressed("parry") and can_parry and !is_parrying:

		start_parry()



	# Movement
	if is_parrying:

		velocity.x = 0


	else:

		# Jump
		if is_on_floor() and Input.is_action_just_pressed("ui_accept"):

			velocity.y = JUMP_VELOCITY

			if jump_sound:
				jump_sound.play()



		# Horizontal movement
		var direction := Input.get_axis("ui_left", "ui_right")


		if direction != 0:

			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0


		else:

			velocity.x = move_toward(velocity.x, 0, SPEED)



	move_and_slide()

	update_animation()



	if position.y > 1600:

		respawn()




func start_parry():

	can_parry = false
	is_parrying = true

	sprite.play("parry")
	invicible_sound.play()



	await get_tree().create_timer(PARRY_STARTUP).timeout


	if !is_parrying:

		return



	parry_area.monitoring = true



	await get_tree().create_timer(PARRY_DURATION).timeout



	parry_area.monitoring = false
	is_parrying = false



	# Cooldown
	await get_tree().create_timer(PARRY_COOLDOWN).timeout



	can_parry = true

	start_ready_flash()




func start_ready_flash():

	ready_flash = true

	var timer := 0.0


	while timer < READY_FLASH_DURATION:

		await get_tree().create_timer(FLASH_SPEED).timeout


		timer += FLASH_SPEED

		flash_on = !flash_on



		if flash_on:

			sprite.modulate = Color(1.5, 1.5, 1.5)

		else:

			sprite.modulate = Color.WHITE



	sprite.modulate = Color.WHITE

	ready_flash = false




func update_animation():

	# Prevent animation from overriding flash
	if ready_flash:

		return



	if is_parrying:

		if sprite.animation != "parry":

			sprite.play("parry")

		return




	# Walking animation used for jumping

	if !is_on_floor() or abs(velocity.x) > 5:


		if sprite.animation != "walk":

			sprite.play("walk")


	else:


		if sprite.animation != "idle":

			sprite.play("idle")





func _on_parry_area_area_entered(area):

	if area.is_in_group("parryable"):

		area.queue_free()





func respawn():

	if dead:

		return


	screech_sound.play()
	dead = true

	Global.timer_running = false


	velocity = Vector2.ZERO

	is_parrying = false
	can_parry = false

	parry_area.monitoring = false

	sprite.modulate = Color.WHITE



	await Transition.change_scene("res://scenes/died.tscn")
