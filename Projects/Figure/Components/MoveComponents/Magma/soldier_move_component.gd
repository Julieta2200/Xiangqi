extends MoveComponent


func move_animation(old_pos: Vector2, new_pos: Vector2) -> void:
	var direction = old_pos - new_pos
	
	if direction.y > 0:
		animated_sprite.play("move_back")
	elif direction.x > 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")
