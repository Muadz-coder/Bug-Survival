extends CharacterBody2D




const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var start_position = Vector2(488,472)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED

		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


	#RespawnVoid
	if position.y > 1000:
		respawn()

func respawn():
	position = start_position
