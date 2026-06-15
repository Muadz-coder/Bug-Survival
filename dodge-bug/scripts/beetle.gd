extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 400
const JUMP_VELOCITY = -725
var start_position = Vector2(1149, 1091)
var jump_count = 0
var max_jumps = 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	#RespawnVoid
	if position.y > 1600:
		respawn()

func respawn():
	position = start_position
