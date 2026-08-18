extends Area2D

var direction := Vector2.ZERO
var speed := 1000


func _ready():
	add_to_group("parryable")
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body):

	if body.is_in_group("player"):

		# Parry beats damage
		if body.get("is_parrying"):
			queue_free()
			return

		if body.get("is_invincible"):
			return

		if body.has_method("respawn"):
			body.respawn()

		queue_free()
	else:
		queue_free()
		
