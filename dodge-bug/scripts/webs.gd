extends Area2D

const SPEED = 900

var direction: Vector2 = Vector2.ZERO
var already_hit = false

signal hooked(position: Vector2)

func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if already_hit:
		return

	if body.is_in_group("player"):
		return

	var hit_pos = global_position - direction * 12

	# 🧠 check if point is inside a wall
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point(hit_pos, 1)

	if result.size() > 0:
		return # cancel bad hook

	already_hit = true

	emit_signal("hooked", hit_pos)
	queue_free()
