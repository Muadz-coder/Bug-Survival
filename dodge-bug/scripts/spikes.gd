extends Area2D

@onready var life_timer = $LifeTimer

func _ready():
	life_timer.timeout.connect(_on_life_timer_timeout)
	body_entered.connect(_on_body_entered)

func _on_life_timer_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("respawn"):
		if body.get("is_invincible"):
			queue_free()
			return

		body.respawn()
