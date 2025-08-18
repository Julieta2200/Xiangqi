extends MoveComponent


func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animated_sprite.play("move_back")
	elif direction.x > 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")

func disappear_animation(target_pos: Vector2i, attacker_pos: Vector2i):
	var direction = target_pos - attacker_pos
	
	if direction.y < 0:
		animated_sprite.play("disappear_back")
	elif direction.y > 0:
		animated_sprite.play("disappear_front")
	elif direction.x > 0:
		animated_sprite.play("disappear_left")
	else:
		animated_sprite.play("disappear_right")

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("disappear") != -1:
		figure_component.delete()
	animated_sprite.play("idle")

func disappear(attacker_pos: Vector2i):
	if attacker_pos == Vector2i(-1,-1):
		animated_sprite.play("disappear_back")
		return
	disappear_animation(figure_component.chess_component.position,attacker_pos)
