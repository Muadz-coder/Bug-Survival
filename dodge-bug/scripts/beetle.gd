extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -725

var jump_count = 0
var max_jumps = 2

func _ready():
	add_to_group("player")
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		if velocity.y < 0:
			# Going up
			velocity += get_gravity() * delta
		else:
			# Falling
			velocity += get_gravity() * 2.0 * delta
	else:
		jump_count = 0



	# Jump
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Fall death
	if position.y > 1600:
		respawn()

func respawn():
	Global.timer_running = false
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://scenes/died.tscn")
