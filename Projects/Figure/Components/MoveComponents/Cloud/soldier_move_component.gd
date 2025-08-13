extends MoveComponent


func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y > 0:
		animated_sprite.play("move_front")
	elif direction.x > 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")
