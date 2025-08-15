extends MoveComponent


func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0 and direction.x > 0:
		animated_sprite.play("move_back_left")
	elif direction.y < 0 and direction.x < 0:
		animated_sprite.play("move_back_right")
	elif direction.y > 0 and direction.x > 0:
		animated_sprite.play("move_front_left")
	else:
		animated_sprite.play("move_front_right")
