extends MoveComponent

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	if direction.y > 0 and direction.x < 0:
		if shadow != null:
			shadow.play("move_front_right")
		animated_sprite.play("move_front_right")
	else:
		if shadow != null:
			shadow.play("idle")
		animated_sprite.play("idle")


func _on_move_done() -> void:
	if shadow != null:
		shadow.play("idle")
	animated_sprite.play("idle")
