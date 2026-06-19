extends Area2D

var direction := Vector2.ZERO
var speed := 1000


func _physics_process(delta):
	global_position += direction * speed * delta


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.get("is_invincible"):
			queue_free()
			return
		if body.has_method("respawn"):
			body.respawn()

	queue_free()
