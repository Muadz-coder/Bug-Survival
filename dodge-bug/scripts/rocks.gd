extends StaticBody2D

var original_position: Vector2
var pressed_position: Vector2
var is_pressed := false
var tween: Tween

func _ready() -> void:
	original_position = position
	pressed_position = position + Vector2(0, 15)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_pressed:
		is_pressed = true

		if tween:
			tween.kill()

		tween = create_tween()
		tween.tween_property(self, "position", pressed_position, 0.7)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Small delay prevents the platform from popping back up
		# from tiny collision/detection changes.
		await get_tree().create_timer(0.1).timeout

		if not _player_is_inside():
			is_pressed = false

			if tween:
				tween.kill()

			tween = create_tween()
			tween.tween_property(self, "position", original_position, 0.2)

func _player_is_inside() -> bool:
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true

	return false
