extends MoveComponent

var animation : String

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y > 0:
		animation = "move_front"
	elif direction.x > 0:
		animation = "move_left"
	else:
		animation = "move_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("disappear") != -1:
		figure_component.delete()
	super._on_figure_animation_finished()
