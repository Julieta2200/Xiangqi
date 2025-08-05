extends MoveComponent


func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animated_sprite.play("move_back")
	elif direction.y > 0:
		animated_sprite.play("move_front")
	elif direction.x > 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")

func generate_move_tween(target_pos):
	await get_tree().create_timer(0.5).timeout
	super.generate_move_tween(target_pos)
