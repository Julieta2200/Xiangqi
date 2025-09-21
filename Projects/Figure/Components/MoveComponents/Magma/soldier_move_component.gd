extends MoveComponent

var animation : String

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animation = "move_back"
	elif direction.x > 0:
		animation = "move_left"
	else:
		animation = "move_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func disappear_animation(target_pos: Vector2i, attacker_pos: Vector2i):
	var direction = target_pos - attacker_pos
	
	if direction.y < 0:
		animation = "disappear_back"
	elif direction.y > 0:
		animation = "disappear_front"
	elif direction.x > 0:
		animation = "disappear_left"
	else:
		animation = "disappear_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("disappear") != -1:
		figure_component.delete()
	if shadow != null:
		shadow.play("idle")
	animated_sprite.play("idle")

func disappear(attacker_pos: Vector2i):
	if attacker_pos == Vector2i(-1,-1):
		if shadow != null:
			shadow.play("disappear_back")
		animated_sprite.play("disappear_back")
		return
	disappear_animation(figure_component.chess_component.position,attacker_pos)
