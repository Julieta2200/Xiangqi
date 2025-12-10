extends MoveComponent

var animation : String

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animation = "move_back"
	elif direction.y > 0:
		animation = "move_front"
	elif direction.x > 0:
		animation = "move_left"
	else:
		animation = "move_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func generate_move_tween(target_pos):
	if get_tree() == null:
		return
	await get_tree().create_timer(0.5).timeout
	super.generate_move_tween(target_pos)
